module BunnyCarrot
  class BusinessActor < LoggingActor

    def initialize
      super()
      logger.info 'Business actor initialized'
    end

    def act(message_hash)
      payload = message_hash.fetch(:payload)
      worker  = message_hash.fetch(:worker)
      headers = message_hash.fetch(:message_headers)
      logger.info "Business #{self.object_id} is acting: #{payload.inspect}"
      worker.run(payload, headers)
      true
    end
  end
end
