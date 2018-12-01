module Kushojin
  module ControllerMethods
    module Callback
      # Send recorded changes.
      #
      #   class UsersController < ApplicationController
      #     send_changes
      #
      #     def create
      #       User.create(user_params)
      #     end
      #
      #     def update
      #       User.find(params[:id]).update(user_params)
      #     end
      #
      #     def destroy
      #       User.find(params[:id]).destroy
      #     end
      #
      #     private
      #
      #     def user_params
      #       params.require(:user).permit(:name)
      #     end
      #   end
      #
      # You can pass in a class or an instance to change behavior of the callback.
      #
      #   class CustomCallback < Kushojin::ControllerMethods::SendChangeCallback
      #     # Must respond to around.
      #     def around(controller)
      #       # Do something
      #       super
      #     end
      #   end
      #
      #   class UsersController < ApplicationController
      #     send_changes CustomCallback.new
      #   end
      #
      # ===== Options
      #
      # * <tt>only</tt> - Send changes only for this action.
      # * <tt>except</tt> - Send changes for all actions except this action.
      #
      def send_changes(callback = nil, **options)
        callback ||= Kushojin::ControllerMethods::SendChangeCallback.new
        around_action callback, options
      end
    end
  end
end
