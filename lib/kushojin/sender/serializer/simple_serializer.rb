module Kushojin
  module Sender
    module Serializer
      class SimpleSerializer < Base
        def self.serialize(change)
          {
            "event"            => change.event.to_s,
            "table_name"       => change.table_name,
            change.primary_key => change.model.id,
            "changes"          => changes_hash(change),
          }
        end

        def self.changes_hash(change)
          change.changes_without_primary_key.reject { |attr_name, _| ignore_columns.include?(attr_name) }
        end
      end
    end
  end
end
