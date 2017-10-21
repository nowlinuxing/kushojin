module Kushojin
  module Sender
    class Base
      def initialize(logger, **_args)
        @logger = logger
      end

      def send(_changes, **_args)
        raise NotImplementedError
      end
    end
  end
end
