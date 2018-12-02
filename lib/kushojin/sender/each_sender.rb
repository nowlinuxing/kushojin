module Kushojin
  module Sender
    class EachSender < Base
      def initialize(logger, serializer: Serializer::SimpleSerializer)
        super
        @serializer = serializer
      end

      def send(changes, controller:)
        tag = generate_tag(controller)
        changes.each do |change|
          @logger.post(tag, serialize(change, controller))
        end
      end

      private

      def generate_tag(controller)
        "#{controller.controller_name}.#{controller.action_name}"
      end

      def serialize(change, controller)
        @serializer.serialize(change).merge!("request_id" => controller.request.request_id)
      end
    end
  end
end
