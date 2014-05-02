require 'bunny_carrot'
require 'logger'
require "stringio"

logger = Logger.new(logfile = File.open('log.log', 'w'))
at_exit { logfile.close }
logger.level = Logger::DEBUG

BunnyCarrot.logger = logger

ENV["RABBITMQ_URL"] = "amqp://127.0.0.1:5672"

EXCHANGE_NAME, QUEUE_NAME, MESSAGE = *ARGV

class BusinessWorker < BunnyCarrot::BaseWorker
  def perform(payload, headers)
    print payload['message']
  end
end

class LoudBusinessWorker < BunnyCarrot::BaseWorker
  def perform(payload, headers)
    print payload['message'].upcase
  end
end



BunnyCarrot::RabbitHole.exchange(name: EXCHANGE_NAME,
                                 type: 'topic')

# sleep 4

BunnyCarrot::Consumer.subscribe(QUEUE_NAME + '1', LoudBusinessWorker.new, block: false, exchange: EXCHANGE_NAME, routing_key: '#')

# sleep 4

BunnyCarrot::Consumer.subscribe(QUEUE_NAME + '2', BusinessWorker.new, block: false, exchange: EXCHANGE_NAME, routing_key: '#')

sleep 1

BunnyCarrot::RabbitHole.publish(queue_name: QUEUE_NAME, payload: { message: MESSAGE },
                                exchange: {
                                  name: EXCHANGE_NAME,
                                  type: 'topic'
                                })

sleep 15
