require "spec_helper"
require "action_controller"
require "kushojin/controller_methods"

RSpec.describe Kushojin::ControllerMethods::Callback do
  describe "#send_changes" do
    let(:callback) do
      Object.new.tap do |obj|
        def obj.around(_controller)
          yield
        end
      end
    end

    let(:controller) do
      klass =
        Class.new(ActionController::API) do
          def create; end
        end
      klass.send_changes callback
      klass.new
    end

    let(:response) { ActionDispatch::Response.new }

    def build_request(method)
      ActionDispatch::Request.new(
        "action_dispatch.request.parameters" => {},
        "REQUEST_METHOD"                     => method.to_s.upcase,
      )
    end

    context "when respond to create" do
      it "should call Callback#around" do
        expect(callback).to receive(:around).with(controller).and_call_original
        controller.dispatch(:create, build_request(:post), response)
      end
    end
  end
end
