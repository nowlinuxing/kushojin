module Kushojin
  module Sender
    module Serializer
      class Base
        def self.default_ignore_columns
          %w[created_at created_on updated_at updated_on]
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
