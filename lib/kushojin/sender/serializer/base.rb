module Kushojin
  module Sender
    module Serializer
      class Base
        def self.default_ignore_columns
          c = Class.new
          c.extend(ActiveRecord::Timestamp::ClassMethods)
          c.class_eval { timestamp_attributes_for_create + timestamp_attributes_for_update }
        end
        private_class_method :default_ignore_columns

        class_attribute :ignore_columns
        self.ignore_columns = default_ignore_columns

        def self.serialize(_change, **_args)
          raise NotImplementedError
        end
      end
    end
  end
end
