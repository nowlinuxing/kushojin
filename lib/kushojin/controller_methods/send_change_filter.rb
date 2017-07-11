module Kushojin
  module ControllerMethods
    class SendChangeFilter
      def initialize(sender: nil)
        @sender = sender || Config.sender
      end

      def around(controller)
        Recorder.build
        yield
        @sender.send(Recorder.changes, controller: controller)
        Recorder.destroy
      end
    end
  end
end
