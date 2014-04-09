require 'spec_helper'
require "securerandom"

ENV["RABBITMQ_URL"] = "amqp://127.0.0.1:5672"

describe "bunny carrot" do
  let(:message) { "works" }
  let(:queue) { "test_bugs_gem_queue" }

  it "allows to send and get message from queues" do
    system "bundle exec ruby spec/fixtures/producer.rb #{queue} #{message}"
    output = `bundle exec ruby spec/fixtures/consumer.rb #{queue}`
    expect(output).to eq message
  end

  it "allows to have producer and consumer in one process" do
    output = `bundle exec ruby spec/fixtures/producer_and_consumer.rb #{queue} #{message}`
    expect(output).to eq message
  end
end
