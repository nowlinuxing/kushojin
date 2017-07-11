require "fluent-logger"
require "kushojin/sender"

module Kushojin
  module Config
    mattr_accessor :logger
    self.logger = Fluent::Logger::ConsoleLogger.open(STDOUT)

    mattr_accessor :sender
    self.sender = Sender::EachSender.new(logger)
  end
end
