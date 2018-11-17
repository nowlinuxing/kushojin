module Kushojin
  module ModelMethods
    module Callback
      RECORD_EVENTS = %i[before_destroy after_create after_update].freeze

      module ClassMethods
        def self.extended(klass)
          klass.class_attribute :kushojin_callbacks, instance_accessor: false
        end

        # Record changes of the ActiveRecord model.
        #
        #   class User < ApplicationRecord
        #     record_changes
        #   end
        #
        # Changes is recorded when the model is created, updated and destroyed.
        # The +:only+ option can be used same as filters of controller.
        #
        #   record_changes only: [:create, :destroy]
        #
        # Custom callback object can be used with +:callbacks+ option.
        #
        #   class CustomCallbacks
        #     # Must respond to after_create, after_update, and before_destroy.
        #     def after_create(record); end
        #     def after_update(record); end
        #     def before_destroy(record); end
        #   end
        #
        #   class User < ApplicationRecord
        #     record_changes callbacks: CustomCallbacks.new
        #   end
        #
        # Both +:only+ and +:callbacks+ option can be overrided by subclass.
        #
        #   class ApplicationRecord < ActiveRecord::Base
        #     self.abstract_class = true
        #     record_changes
        #   end
        #
        #   class User < ApplicationRecord
        #     record_changes only: [:create, :destroy], callbacks: CustomCallbacks.new
        #   end
        #
        # ===== Options
        #
        # * <tt>only</tt> - Records only for this event.
        #   Support event is +:create+, +:update+, and +:destroy+.
        # * <tt>callbacks</tt> - Use callback object instead of RecordChangesCallbacks.
        #
        def record_changes(only: [], callbacks: nil)
          if kushojin_callbacks
            remove_callbacks
            self.kushojin_callbacks = callbacks if callbacks
          else
            self.kushojin_callbacks = callbacks || RecordChangesCallbacks.new
          end

          record_events = convert_to_record_events(only)
          record_events.each do |event|
            public_send(event, kushojin_callbacks)
          end
        end

        private

        def remove_callbacks
          kind_and_names =
            RECORD_EVENTS.map { |event| event.to_s.split("_", 2).map(&:to_sym) }

          kind_and_names.each do |kind, name|
            skip_callback(name, kind, kushojin_callbacks, raise: false)
          end
        end

        def convert_to_record_events(events) # :nodoc:
          if events.empty?
            RECORD_EVENTS
          else
            event_strs = Array(events).map(&:to_s)
            RECORD_EVENTS.select { |event| event_strs.include?(event.to_s.sub(/^\w*_/, "")) }
          end
        end
      end
    end
  end
end
