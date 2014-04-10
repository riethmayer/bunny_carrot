module BunnyCarrot
  module Strategy
    class RestartAndBlock < RestartBase
      def perform
        if restart_attempts_left?
          restart
        else
          logger.info 'No attempts left to restart, blocking queue...'
          block
        end
      end
    end
  end
end

