module BunnyCarrot
  class LoggingActor < Concurrent::Actor
    include BunnyCarrot::Logger

    def on_error(time, msg, ex)
      logger.error "#{time} #{msg.inspect}"
      logger.error ex.inspect
      logger.error ex.backtrace.join("\n")
    end
  end
end
