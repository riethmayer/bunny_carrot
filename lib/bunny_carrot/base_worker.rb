module BunnyCarrot
  class BaseWorker
    include BunnyCarrot::Logger

    STRATEGY_MAP = {
        block:             Strategy::Block,
        drop:              Strategy::Drop,
        restart_and_block: Strategy::RestartAndBlock,
        restart_and_drop:  Strategy::RestartAndDrop
    }

    def self.error_handling_strategies(hash)
      raise 'Invalid strategies hash' unless hash.kind_of? Hash
      @@strategies = hash
    end

    def initialize
      @@strategies ||= {}
    end

    def run(payload, headers)
      perform(payload, headers)
    end

    def strategy(message, exception)
      strategy, restart_count = Array(@@strategies[exception.class])
      strategy                ||= default_strategy
      klass                   = STRATEGY_MAP[strategy]
      klass.nil? ? raise("Undefined queue strategy #{strategy}") : logger.info("Applying #{klass}")
      hash = message.merge(Hamster.hash(restart_count: restart_count))
      klass.new(hash)
    end

    def default_strategy
      :block
    end

    protected

    def perform(payload, headers)
      raise NotImplememtedError
    end
  end
end
