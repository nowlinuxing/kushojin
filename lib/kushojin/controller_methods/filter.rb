module Kushojin
  module ControllerMethods
    module Filter
      def send_changes(filter = nil, **args)
        filter ||= Kushojin::ControllerMethods::SendChangeFilter.new
        around_action filter, args
      end
    end
  end
end
