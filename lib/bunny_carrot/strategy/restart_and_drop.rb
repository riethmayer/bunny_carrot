module BunnyCarrot
  module Strategy
    class RestartAndDrop < RestartBase
      def perform
        if restart_attempts_left?
          restart
        else
          logger.info 'No attempts left to restart, dropping message...'
          drop
        end
      end
    end
  end
end
