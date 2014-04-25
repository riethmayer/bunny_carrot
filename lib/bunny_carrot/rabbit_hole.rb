module BunnyCarrot
  class RabbitHole
    include BunnyCarrot::Logger

    def self.get_subscribe_channel
      @@subscribe_channel ||= new.get_channel
    end

    def self.get_publish_channel
      @@publish_channel ||= new.get_channel
    end

    def initialize
      @rabbit = Bunny.new(BunnyCarrot.server_url,
                          heartbeat_interval: 5, automatically_recover: true,
                          keepalive:          true)
      @rabbit.start
      logger.info 'Rabbit hole initialized'
    end

    def get_channel
      @rabbit.create_channel
    end

    def self.publish(args)
      queue_name = args.fetch(:queue_name)
      payload    = args.fetch(:payload).to_json
      headers    = args.fetch(:headers, {})
      custom_exchange = args.fetch(:exchange, nil)

      get_publish_channel.queue(queue_name, durable: true)
      exchange(custom_exchange).publish(payload,
                       durable: true,
                       routing_key: queue_name,
                       headers:     headers)
    end

    def self.exchange(custom_exchange_params)
      if custom_exchange_params
        get_publish_channel.public_send(custom_exchange_params.fetch(:type),
                                        custom_exchange_params.fetch(:name))
      else
        get_publish_channel.default_exchange
      end
    end
  end
end
