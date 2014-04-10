module BunnyCarrot
  module ExceptionNotification
    class Airbrake < Base
      def notify
          return unless defined?(Airbrake)
          Airbrake.notify(@exception, error_message: message)
      end
    end
  end
end
