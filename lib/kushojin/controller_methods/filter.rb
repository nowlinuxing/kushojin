module Kushojin
  module ControllerMethods
    module Filter
      def send_changes(**args)
        filter = args.delete(:filter) || Kushojin::ControllerMethods::SendChangeFilter.new
        around_action filter, args
      end
    end
  end
end
