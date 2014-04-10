module BunnyCarrot
  module Strategy
    class Drop < Base
      def perform
        logger.info 'Dropping message...'
        drop
      end

      def default_notify
        false
      end
    end
  end
end
