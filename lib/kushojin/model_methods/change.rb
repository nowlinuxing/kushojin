module Kushojin
  module ModelMethods
    class Change
      attr_reader :event, :model

      delegate :primary_key, :table_name, to: "@model.class"

      def initialize(event, model)
        @event = event
        @model = take_copy_of(model).freeze
      end

      # Returns changes of the ActiveRecord model.
      #
      #   class User < ApplicationRecord
      #   end
      #
      #   user = User.create(name: "bill")
      #   Kushojin::ModelMethods::Change.new(:create, user).changes # => { "id" => [nil, 123], "name" => [nil, "bill"], "created_at" => [nil, 2019-01-23 00:00:00 UTC], "updated_at" => [nil, 2019-12-31 12:34:56 UTC]
      #   #   }
      #
      # If a model is updated by +touch+ method, this returns the changed
      # attributes when activerecord is 6.0.0 or later.
      #
      #   # activerecord 5.x
      #   user.touch
      #   Kushojin::ModelMethods::Change.new(:touch, user).changes # => {}
      #
      #   # activerecord 6.x
      #   user.touch
      #   Kushojin::ModelMethods::Change.new(:touch, user).changes # => { "updated_at" => [2019-09-16 15:25:43 UTC, 2019-09-16 16:33:48 UTC] }
      #
      # See https://github.com/rails/rails/issues/33429
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
