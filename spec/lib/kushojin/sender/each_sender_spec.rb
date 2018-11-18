require "spec_helper"

RSpec.describe Kushojin::Sender::EachSender do
  describe "#send" do
    let(:logger) { Fluent::Logger::TestLogger.new }
    let(:controller) { double(:UsersController) }

    let(:user) { User.create(name: "bill", age: 20) }
    let(:changes) do
      changes = []
      changes << Kushojin::ModelMethods::Change.new(:create, user)

      user.update(name: "bob", age: 21)
      changes << Kushojin::ModelMethods::Change.new(:update, user)

      changes
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

    after do
      User.delete_all
    end

    subject do
      sender = Kushojin::Sender::EachSender.new(logger)
      sender.send(changes, controller: controller)
    end

    it do
      subject
      expect(logger.queue[0].tag).to eq("users.action")
      expect(logger.queue[0]).to match(
        "event"      => "create",
        "request_id" => "12345678-9abc-def0-1234-56789abcdef0",
        "table_name" => "users",
        "id"         => user.id,
        "changes"    => {
          "name" => [nil, "bill"],
          "age"  => [nil, 20],
        },
      )

      expect(logger.queue[1].tag).to eq("users.action")
      expect(logger.queue[1]).to match(
        "event"      => "update",
        "request_id" => "12345678-9abc-def0-1234-56789abcdef0",
        "table_name" => "users",
        "id"         => user.id,
        "changes"    => {
          "name" => ["bill", "bob"], # rubocop:disable Style/WordArray
          "age"  => [20, 21],
        },
      )
    end
  end
end
