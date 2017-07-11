require "spec_helper"
require "kushojin/controller_methods/send_change_filter"

RSpec.describe Kushojin::ControllerMethods::SendChangeFilter do
  describe "#around" do
    let(:logger) { spy("Fluent::Logger::TestLogger") }
    let(:controller) { double(:UsersController) }
    let(:callback) do
      sender = Kushojin::Sender::EachSender.new(logger)
      Kushojin::ControllerMethods::SendChangeFilter.new(sender: sender)
    end

    before do
      req = double("ActionDispatch::Request")

      allow(controller).to receive_messages(
        controller_name: "users",
        action_name:     "action",
        request:         req,
      )
      allow(req).to receive(:request_id).and_return("12345678-9abc-def0-1234-56789abcdef0")
    end

    it do
      map1 = {
        "event"      => "create",
        "request_id" => "12345678-9abc-def0-1234-56789abcdef0",
        "table_name" => "users",
        "id"         => an_instance_of(Integer),
        "changes"    => {
          "name" => [nil, "bill"],
          "age"  => [nil, 20],
        },
      }
      expect(logger).to receive(:post).with("users.action", map1)

      map2 = {
        "event"      => "update",
        "request_id" => "12345678-9abc-def0-1234-56789abcdef0",
        "table_name" => "users",
        "id"         => an_instance_of(Integer),
        "changes"    => {
          "name" => ["bill", "bob"], # rubocop:disable Style/WordArray
        },
      }
      expect(logger).to receive(:post).with("users.action", map2)

      callback.around(controller) do
        user = User.create(name: "bill", age: 20)
        user.update(name: "bob")
      end
    end
  end
end
