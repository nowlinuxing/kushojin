module Kushojin
  module ModelMethods
    class RecordChangesCallbacks
      Callback::RECORD_EVENTS.each do |event|
        callback = event.to_s.split(/_/).last

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{event}(model)                           # def after_create(model)
            return unless Recorder.current              #   return unless Recorder.current
                                                        #
            change = build_change_on_#{callback}(model) #   change = build_change_on_create(model)
            Recorder.record(change)                     #   Recorder.record(change)
          end                                           # end
        RUBY

        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def build_change_on_#{callback}(model)          # def build_change_on_create(model)
            ModelMethods::Change.new(:#{callback}, model) #   ModelMethods::Change.new(:create, model)
          end                                             # end
          private :build_change_on_#{callback}            # private :build_change_on_create
        RUBY
      end
    end
  end
end
