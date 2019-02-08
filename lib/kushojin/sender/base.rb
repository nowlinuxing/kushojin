module Kushojin
  module Sender
    class Base
      def initialize(logger = nil, **_args)
        @logger = logger || Config.logger
      end

      def send(_changes, **_args)
        raise NotImplementedError
      end
    end
  end
end
