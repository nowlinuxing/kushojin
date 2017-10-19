module Kushojin
  module ModelMethods
    class RecordChangesCallbacks
      Callback::RECORD_EVENTS.each do |event|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{event}(model)                                                          # def after_create
          Recorder.record(:#{event.to_s.split(/_/).last}, model) if Recorder.current #   Recorder.record(:create, model) if Recorder.current
        end                                                                          # end
        RUBY
      end
    end
  end
end
