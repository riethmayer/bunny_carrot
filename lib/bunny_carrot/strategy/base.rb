module BunnyCarrot
  module Strategy
    class Base
      include BunnyCarrot::Logger

      def initialize(args)
        @queue_name       = args.fetch(:queue_name)
        @payload          = args.fetch(:payload)
        @headers          = args.fetch(:message_headers)
        @acknowledge_proc = args.fetch(:acknowledge_proc)
        post_initialize(args)
      end

      def perform
        raise NotImplementedError
      end

      protected

      def post_initialize(args)
      end

      private

      def acknowledge
        @acknowledge_proc.call
      end

      def publish
        RabbitHole.publish(payload:    @payload,
                           queue_name: @queue_name,
                           headers:    headers)
      end

      def headers
        @headers
      end
    end
  end
end
