require 'concurrent'
require 'hamster'
require 'bunny'
require 'json'
require 'bunny_carrot/logger'
require 'bunny_carrot/exception_notification/base'
require 'bunny_carrot/exception_notification/airbrake'
require 'bunny_carrot/exception_notifier'
require 'bunny_carrot/strategy/base'
require 'bunny_carrot/strategy/restart_base'
require 'bunny_carrot/strategy/block'
require 'bunny_carrot/strategy/drop'
require 'bunny_carrot/strategy/restart_and_block'
require 'bunny_carrot/strategy/restart_and_drop'
require 'bunny_carrot/rabbit_hole'
require 'bunny_carrot/logging_actor'
require 'bunny_carrot/business_actor'
require 'bunny_carrot/business_actor_observer'
require 'bunny_carrot/consumer_actor'
require 'bunny_carrot/consumer'
require 'bunny_carrot/base_worker'


module BunnyCarrot
  def self.server_url
    @server_url ||= ENV["RABBITMQ_URL"]
  end

  def self.server_url=(url)
    @server_url = url
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Logger.new($stdout)
  end
end
