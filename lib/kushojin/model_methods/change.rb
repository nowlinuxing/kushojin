module Kushojin
  module ModelMethods
    class Change
      attr_reader :event, :model, :changes

      def initialize(event, model)
        @event = event
        @model = model.class.new(model.attributes).freeze
        @changes = model.saved_changes.freeze
      end
    end
  end
end
