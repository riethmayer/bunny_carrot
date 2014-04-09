require 'bunny_carrot'
require 'logger'
require "stringio"

logger = Logger.new(StringIO.new)
BunnyCarrot.logger = logger

ENV["RABBITMQ_URL"] = "amqp://127.0.0.1:5672"

QUEUE_NAME = ARGV[0]

class BusinessWorker < BunnyCarrot::BaseWorker
  def perform(payload, headers)
    print payload['message']
  end
end

begin
  Timeout.timeout(5) do
    BunnyCarrot::Consumer.subscribe(QUEUE_NAME, BusinessWorker.new, block: true)
  end
rescue Timeout::Error
end

