module BunnyCarrot
  class BusinessActorObserver
    include BunnyCarrot::Logger

    def self.update(time, message_args, result, exception)
      message = message_args.first
      logger.info "Observing business..."
      if result
        message.fetch(:acknowledge_proc).call
        logger.info 'Message is acknowledged'
      else
        logger.info "Rejected because of: #{exception.inspect}"
        message_attrs = Hamster.hash({ queue_name:       message.fetch(:queue_name),
                                       payload:          message.fetch(:payload),
                                       message_headers:  message.fetch(:message_headers),
                                       acknowledge_proc: message.fetch(:acknowledge_proc),
                                       exception:        exception })
        worker        = message.fetch(:worker)
        logger.info 'Defining exception handling strategy...'
        strategy = worker.strategy(message_attrs)
        strategy.perform
      end
    end
  end
end
