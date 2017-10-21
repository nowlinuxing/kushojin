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

      def map(change, controller:)
        changes = change.changes_without_primary_key.reject { |attr_name, _| ignore_columns.include?(attr_name) }
        {
          "event"            => change.event.to_s,
          "request_id"       => controller.request.request_id,
          "table_name"       => change.table_name,
          change.primary_key => change.model.id,
          "changes"          => changes,
        }
      end
    end
  end
end
