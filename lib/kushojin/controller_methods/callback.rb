module Kushojin
  module ControllerMethods
    module Callback
      def send_changes(callback = nil, **options)
        callback ||= Kushojin::ControllerMethods::SendChangeCallback.new
        around_action callback, options
      end
    end
  end
end
