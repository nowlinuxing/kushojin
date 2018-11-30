module Kushojin
  module ModelMethods
    class Change
      attr_reader :event, :model

      delegate :primary_key, :table_name, to: "@model.class"

      def initialize(event, model)
        @event = event
        @model = take_copy_of(model).freeze
      end

      def changes
        @model.saved_changes
      end

      def changes_without_primary_key
        changes.reject { |attr_name, _| attr_name == primary_key }
      end

      private

      class_attribute :copy_ivars, instance_writer: false
      self.copy_ivars = %i[
        @attributes
        @mutations_before_last_save
      ]

      def take_copy_of(model)
        model.class.new do |copy|
          copy_ivars.each do |ivar|
            copy.instance_variable_set(ivar, model.instance_variable_get(ivar).deep_dup)
          end
        end
      end
    end
  end
end
