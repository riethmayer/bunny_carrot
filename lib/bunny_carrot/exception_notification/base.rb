module BunnyCarrot
  module ExceptionNotification
    class Base
      def self.notify(args)
        new(args).notify
      end

      def initialize(args)
        @queue_name = args.fetch(:queue_name)
        @payload    = args.fetch(:payload)
        @exception  = args.fetch(:exception)
      end

      def message
        "queue: #{@queue_name}, payload: #{@payload}"
      end

      def notify?
        true
      end
    end
  end
end
