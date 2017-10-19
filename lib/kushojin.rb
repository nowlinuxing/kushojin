require "active_record"
require "kushojin/version"
require "kushojin/config"
require "kushojin/model_methods"
require "kushojin/recorder"
require "kushojin/model_methods"
require "kushojin/sender"

module Kushojin
end

ActiveRecord::Base.extend Kushojin::ModelMethods::Callback::ClassMethods
