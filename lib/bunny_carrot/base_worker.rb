module BunnyCarrot
  class BaseWorker
    include BunnyCarrot::Logger

    def self.error_handling_strategies(hash)
      raise 'Invalid strategies hash' unless hash.kind_of? Hash
      @strategies = hash
    end

    def initialize
      @strategies = strategies || {}
    end

    def run(payload, headers)
      perform(payload, headers)
    end

    def strategy(message_attrs)
      hash = Hamster.hash(mapping: @@strategies, message_attrs: message_attrs)
      ExceptionStrategy.get(hash)
    end

    protected

    def perform(payload, headers)
      raise NotImplememtedError
    end

    def strategies
      self.class.instance_eval { @strategies }
    end
  end
end
