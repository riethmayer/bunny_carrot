module BunnyCarrot
  module Strategy
    class Drop < Base
      def perform
        logger.info 'Dropping message...'
        acknowledge
      end
    end
  end
end
