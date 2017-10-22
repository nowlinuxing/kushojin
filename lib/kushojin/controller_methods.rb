require "kushojin/controller_methods/filter"
require "kushojin/controller_methods/send_change_filter"

ActionController::Metal.extend Kushojin::ControllerMethods::Filter
