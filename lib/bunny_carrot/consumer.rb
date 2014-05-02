module BunnyCarrot
  class Consumer
    include BunnyCarrot::Logger

    def self.subscribe(queue_name, worker, pool_size: 1, **args)
      @@consumer ||= self.new(pool_size: pool_size)
      @@consumer.subscribe(queue_name, worker, **args)
    end

    def initialize(pool_size: 1)
      @supervisor         = Concurrent::Supervisor.new

      business_actor, business_pool = BusinessActor.pool(pool_size)
      business_pool.each do |actor|
        actor.add_observer(BusinessActorObserver)
        @supervisor.add_worker(actor)
      end

      @consumer_actor = ConsumerActor.new(business_actor, pool_size)
      @supervisor.add_worker(@consumer_actor)

      @supervisor.run!
      until @supervisor.running? && @consumer_actor.running?
        sleep(0.1)
      end

      logger.info 'Supervisor started'
    end


    def subscribe(queue_name, worker, block: false,
                  exchange: nil, routing_key: nil)
      @consumer_actor.post(queue_name, worker, exchange, routing_key)
      loop { sleep(1) } if block
    end
  end
end
