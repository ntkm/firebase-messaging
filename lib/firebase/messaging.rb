require 'faraday'
require 'faraday_middleware'
require 'firebase/messaging/version'
require 'firebase/messaging/configure'
require 'firebase/messaging/client'
require 'firebase/messaging/error'
require 'firebase/messaging/request'

module Firebase
  module Messaging
    # firebase settings
    #   Firebase::Messaging.configure do |config|
    #     config.server_key = "your-firebase-server-key"
    #   end
    class << self
      def configure
        if block_given?
          yield config
        else
          config
        end
      end

      def logger
        Firebase::Messaging::Logger.new(config.logger, level: config.logger_level)
      end

      private

      def config
        @config ||= Configure.new
      end
    end
  end
end
