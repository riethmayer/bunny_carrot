module BunnyCarrot
  module Strategy
    class RestartAndBlock < Base

      def perform
        if restart_attempts_left?
          logger.info "Requeuing with attempt: #{@restart_attempt}"
          acknowledge
          publish
        end
      end

      protected

      def post_initialize(args)
        @restart_count = args.fetch(:restart_count, 5)
        increase_attempt_count
      end

      private

      def restart_attempts_left?
        @restart_attempt <= @restart_count
      end

      def headers
        super.merge(Hamster.hash('restart_attempt' => @restart_attempt))
      end

      def increase_attempt_count
        @restart_attempt = (@headers['restart_attempt'] || 0) + 1
      end
    end
  end
end

