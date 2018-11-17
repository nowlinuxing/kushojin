module Kushojin
  module ModelMethods
    module Callback
      RECORD_EVENTS = %i[before_destroy after_create after_update].freeze

      module ClassMethods
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
        # ===== Options
        #
        # * <tt>only</tt> - Records only for this event.
        #   Support event is +:create+, +:update+, and +:destroy+.
        #
        def record_changes(only: [])
          record_events = convert_to_record_events(only)

          kushojin_callbacks = RecordChangesCallbacks.new
          record_events.each do |event|
            public_send(event, kushojin_callbacks)
          end
        end

        private

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
