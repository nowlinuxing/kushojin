module Kushojin
  class Recorder
    THREAD_KEY = "kushojin.recorder".freeze

    attr_reader :changes

    (class << self; self; end).delegate :changes, :record, to: :current

    def self.build
      Thread.current[THREAD_KEY] = new
    end

    def self.current
      Thread.current[THREAD_KEY]
    end

    def self.destroy
      Thread.current[THREAD_KEY] = nil
    end

    def initialize
      @changes = []
    end

    def record(event, model)
      @changes << ModelMethods::Change.new(event, model)
    end
  end
end
