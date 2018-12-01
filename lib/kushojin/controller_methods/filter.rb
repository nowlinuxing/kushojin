module Kushojin
  module ControllerMethods
    module Filter
      def send_changes(filter = nil, **options)
        filter ||= Kushojin::ControllerMethods::SendChangeFilter.new
        around_action filter, options
      end
    end
  end
end
