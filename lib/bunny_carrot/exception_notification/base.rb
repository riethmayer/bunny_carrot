module BunnyCarrot
  module ExceptionNotification
    class Base
      include BunnyCarrot::Logger

      def self.notify(args)
        new(args).notify
      end

      def initialize(args)
        @queue_name = args.fetch(:queue_name)
        @payload    = args.fetch(:payload)
        @exception  = args.fetch(:exception)
      end

      def notify
        rails NotImplementedError
      end

      def message
        "#{@exception.message}, queue: #{@queue_name}, payload: #{@payload}"
      end

      def notify?
        true
      end
    end
  end
end
