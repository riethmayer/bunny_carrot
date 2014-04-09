module BunnyCarrot
  class ConsumerActor < LoggingActor

    def initialize(business_actor, pool_size)
      super()
      @business_actor = business_actor
      @pool_size      = pool_size
      logger.info 'Consumer actor initialized'
    end

    def act(queue_name, worker)
      logger.info "Consumer is acting..."
      queue = channel.queue(queue_name, durable: true)
      queue.subscribe(block: true, ack: true) do |delivery_info, properties, payload|
        acknowledge_proc = lambda { channel.ack(delivery_info.delivery_tag) }
        message_hash     = Hamster.hash({ queue_name:       queue_name,
                                          payload:          JSON.parse(payload),
                                          message_headers:  Hamster.hash(properties.headers || {}),
                                          acknowledge_proc: acknowledge_proc,
                                          worker:           worker })
        @business_actor.post(message_hash)
      end
    end

    private

    def channel
      @channel ||= RabbitHole.get_subscribe_channel.tap { |c|
        c.prefetch(@pool_size); logger.info 'Ready to consume!' }
    end
  end
end
