module Kushojin
  module Sender
    class EachSender < Base
      def initialize(logger, serializer: Serializer::SimpleSerializer)
        super
        @serializer = serializer
      end

      def send(changes, controller:)
        changes.each do |change|
          @logger.post(tag(controller), @serializer.serialize(change, controller: controller))
        end
      end

      private

      def tag(controller)
        "#{controller.controller_name}.#{controller.action_name}"
      end
    end
  end
end
