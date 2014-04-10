module BunnyCarrot
  class ExceptionStrategy
    include BunnyCarrot::Logger

    TYPES = {
        block:             Strategy::Block,
        drop:              Strategy::Drop,
        restart_and_block: Strategy::RestartAndBlock,
        restart_and_drop:  Strategy::RestartAndDrop
    }

    def self.get(args)
      new(args).get
    end

    def initialize(args)
      mapping        = args.fetch(:mapping)
      @message_attrs = args.fetch(:message_attrs)
      exception      = @message_attrs.fetch(:exception)
      @strategy_name, @restart_count = Array(mapping[exception.class])
      @strategy_name ||= default_strategy
      @strategy_class = TYPES[@strategy_name]
      @strategy_class.nil? ?
          raise("Undefined queue strategy #{@strategy_name}") : logger.info("Applying #{@strategy_class}")
    end

    def get
      hash = @message_attrs.merge(Hamster.hash(restart_count: @restart_count))
      strategy_class.new(hash)
    end

    def default_strategy
      :block
    end
  end
end
