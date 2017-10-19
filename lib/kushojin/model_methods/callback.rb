module Kushojin
  module ModelMethods
    module Callback
      RECORD_EVENTS = %i[before_destroy after_create after_update].freeze

      module ClassMethods
        def record_changes
          kushojin_callbacks = RecordChangesCallbacks.new
          RECORD_EVENTS.each do |event|
            public_send(event, kushojin_callbacks)
          end
        end
      end
    end
  end
end
