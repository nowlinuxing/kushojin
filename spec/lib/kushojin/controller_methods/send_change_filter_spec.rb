require "spec_helper"
require "kushojin/controller_methods/send_change_filter"

RSpec.describe Kushojin::ControllerMethods::SendChangeFilter do
  describe "#around" do
    let(:logger) { Fluent::Logger::TestLogger.new }
    let(:callback) do
      sender = Kushojin::Sender::EachSender.new(logger)
      Kushojin::ControllerMethods::SendChangeFilter.new(sender: sender)
    end

    before do
      controller = double(:UsersController)
      req = double("ActionDispatch::Request")

      allow(controller).to receive_messages(
        controller_name: "users",
        action_name:     "action",
        request:         req,
      )
      allow(req).to receive(:request_id).and_return("12345678-9abc-def0-1234-56789abcdef0")

      callback.around(controller) do
        user = User.create(name: "bill", age: 20)
        user.update(name: "bob")
      end
    end

    after do
      User.delete_all
    end

    it "should record a create log" do
      expect(logger.queue[0].tag).to eq("users.action")
      expect(logger.queue[0]).to match(
        "event"      => "create",
        "request_id" => "12345678-9abc-def0-1234-56789abcdef0",
        "table_name" => "users",
        "id"         => an_instance_of(Integer),
        "changes"    => {
          "name" => [nil, "bill"],
          "age"  => [nil, 20],
        },
      )
    end

    it "should record a update log" do
      expect(logger.queue[1].tag).to eq("users.action")
      expect(logger.queue[1]).to match(
        "event"      => "update",
        "request_id" => "12345678-9abc-def0-1234-56789abcdef0",
        "table_name" => "users",
        "id"         => an_instance_of(Integer),
        "changes"    => {
          "name" => ["bill", "bob"], # rubocop:disable Style/WordArray
        },
      )
    end
  end
end
