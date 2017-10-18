module Kushojin
  module ModelMethods
    class Change
      attr_reader :event, :model, :changes

      delegate :primary_key, :table_name, to: "@model.class"

      def initialize(event, model)
        @event = event
        @model = model.class.new(model.attributes).freeze
        @changes = model.saved_changes.freeze
      end

      def changes_without_primary_key
        @changes.reject { |attr_name, _| attr_name == primary_key }
      end
    end
  end
end
