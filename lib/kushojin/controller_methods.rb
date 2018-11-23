require "kushojin/controller_methods/callback"
require "kushojin/controller_methods/send_change_callback"

ActionController::Metal.extend Kushojin::ControllerMethods::Callback
