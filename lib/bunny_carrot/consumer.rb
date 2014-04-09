module BunnyCarrot
  class Consumer
    include BunnyCarrot::Logger

    def self.subscribe(queue_name, worker, pool_size: 1, block: false)
      root_supervisor          = Concurrent::Supervisor.new
      queue_supervisor         = Concurrent::Supervisor.new(restart_strategy: :one_for_all)
      business_pool_supervisor = Concurrent::Supervisor.new
      root_supervisor.add_worker(queue_supervisor)
      root_supervisor.add_worker(business_pool_supervisor)


      business_actor, business_pool = BusinessActor.pool(pool_size)
      business_pool.each do |actor|
        actor.add_observer(BusinessActorObserver)
        business_pool_supervisor.add_worker(actor)
      end

      consumer_actor = ConsumerActor.new(business_actor, pool_size)
      queue_supervisor.add_worker(consumer_actor)

      root_supervisor.run!
      until root_supervisor.running? && queue_supervisor.running? && business_pool_supervisor.running?
        sleep(0.1)
      end

      logger.info 'Starting consuming...'

      consumer_actor.post(queue_name, worker)
      loop { sleep(1) } if block
    end
  end
end
