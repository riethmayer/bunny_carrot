module BunnyCarrot
  module Strategy
    class RestartBase < Base

      protected

      def post_initialize(args)
        @restart_count = args.fetch(:restart_count, 5)
        increase_attempt_count
      end

      def restart
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
    end
  end
end

