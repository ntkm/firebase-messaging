module Firebase
  module Messaging
    class Logger
      attr_reader :logger, :level

      LOGGER_LEVELS = [:fatal, :error, :warn, :info, :debug].freeze

      def initialize(logger, level: :warn)
        @logger = logger
        @level = level
      end

      LOGGER_LEVELS.each do |method|
        define_method method.to_s do |message|
          if LOGGER_LEVELS.index(method) <= LOGGER_LEVELS.index(level)
            logger.send(method, 'Firebase::Messaging: %s' % [message.gsub(/[\r\n]/, '')])
          end
        end
      end
    end
  end
end
