module BunnyCarrot
  module Logger
    def self.included(base)
      base.extend self
    end

    def logger
      BunnyCarrot.logger
    end
  end
end
