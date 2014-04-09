module BunnyCarrot
  module Strategy
    class Block < Base
      def perform
        logger.info 'Blocking queue...'
        # Doing nothing, blocking queue
      end
    end
  end
end
