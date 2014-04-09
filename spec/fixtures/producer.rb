require 'bunny_carrot'
require 'logger'
require "stringio"

logger = Logger.new(StringIO.new)
BunnyCarrot.logger = logger

ENV["RABBITMQ_URL"] = "amqp://127.0.0.1:5672"

QUEUE_NAME, MESSAGE = *ARGV

BunnyCarrot::RabbitHole.publish queue_name: QUEUE_NAME, payload: { message: MESSAGE }
sleep 1
