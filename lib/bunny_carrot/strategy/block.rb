module BunnyCarrot
  module Strategy
    class Block < Base
      def perform
        logger.info 'Blocking queue...'
        block
      end
    end
  end
end
