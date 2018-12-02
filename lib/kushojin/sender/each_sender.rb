module Kushojin
  module Sender
    class EachSender < Base
      def initialize(logger, serializer: Serializer::SimpleSerializer)
        super
        @serializer = serializer
      end

      def send(changes, controller:)
        changes.each do |change|
          @logger.post(tag(controller), serialize(change, controller))
        end
      end

      private

      def tag(controller)
        "#{controller.controller_name}.#{controller.action_name}"
      end

      def serialize(change, controller)
        @serializer.serialize(change, controller: controller)
      end
    end
  end
end
