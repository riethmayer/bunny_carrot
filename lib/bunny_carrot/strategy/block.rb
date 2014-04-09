module BunnyCarrot
  module Strategy
    class Block < Base
      def perform
        logger.info 'Blocking queue...'
        # Do nothing, block queue
      end
    end
  end
end
