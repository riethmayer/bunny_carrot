module BunnyCarrot
  module Strategy
    class RestartBase < Base

      protected

      def post_initialize(args)
        @restart_count = args.fetch(:restart_count, 5)
        increase_attempt_count
      end

      def restart
        delay_restart
        logger.info "Requeuing with attempt: #{@restart_attempt}"
        acknowledge
        publish
      end

      def restart_attempts_left?
        @restart_attempt <= @restart_count
      end

      private

      def headers
        super.merge(Hamster.hash('restart_attempt' => @restart_attempt))
      end

      def increase_attempt_count
        @restart_attempt = (@headers['restart_attempt'] || 0) + 1
      end

      def delay_restart
        sleep(delay)
      end

      # 0 sec for 1st restart, 1 sec for 2nd, 3.3 secs for 10th, 10 secs for 1000th
      def delay
        Math::log(@restart_attempt, 2)
      end
    end
  end
end

