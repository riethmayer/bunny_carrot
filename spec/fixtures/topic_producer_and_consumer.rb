require 'bunny_carrot'
require 'logger'
require "stringio"

logger = Logger.new(StringIO.new)
logger.level = Logger::INFO

BunnyCarrot.logger = logger

ENV["RABBITMQ_URL"] = "amqp://127.0.0.1:5672"

EXCHANGE_NAME, QUEUE_NAME, MESSAGE = *ARGV

sleep 1

class BusinessWorker < BunnyCarrot::BaseWorker
  def perform(payload, headers)
    print payload['message']
  end
end


BunnyCarrot::RabbitHole.exchange(name: EXCHANGE_NAME,
                                 type: 'topic')

BunnyCarrot::Consumer.subscribe(QUEUE_NAME, BusinessWorker.new, block: false, exchange: EXCHANGE_NAME, routing_key: '#')

sleep 1

BunnyCarrot::RabbitHole.publish(queue_name: QUEUE_NAME, payload: { message: MESSAGE },
                                exchange: {
                                  name: EXCHANGE_NAME,
                                  type: 'topic'
                                })

sleep 1
