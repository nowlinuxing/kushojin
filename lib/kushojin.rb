require "active_record"
require "kushojin/version"
require "kushojin/config"
require "kushojin/model_methods"
require "kushojin/recorder"
require "kushojin/model_methods"
require "kushojin/sender"
require "kushojin/controller_methods" if defined?(AbstractController)

module Kushojin
end

ActiveRecord::Base.extend Kushojin::ModelMethods::Callback::ClassMethods
