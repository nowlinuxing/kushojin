require "fluent-logger"

module Kushojin
  module Config
    mattr_accessor :logger
    self.logger = Fluent::Logger::ConsoleLogger.open(STDOUT)
  end
end
