module BunnyCarrot
  module Strategy
    class RestartAndDrop < RestartAndBlock
      def perform
        super
        unless restart_attempts_left?
          logger.info 'No restart attempts left, dropping message...'
          acknowledge
        end
      end
    end
  end
end
