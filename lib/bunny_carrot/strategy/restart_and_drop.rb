module BunnyCarrot
  module Strategy
    class RestartAndDrop < RestartAndBlock
      def perform
        super
        unless restart_attempts_left?
          logger.info 'No attempts left to restart, dropping message...'
          acknowledge
        end
      end
    end
  end
end
