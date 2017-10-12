require 'faraday'
require 'faraday_middleware'
require 'instance_id/configure'
require 'instance_id/client'
require 'instance_id/request'
require 'instance_id/request/get_info'
require 'instance_id/request/delete'

module InstanceId
  # firebase settings
  #   Firebase::Messaging.configure do |config|
  #     config.server_key = "your-server-key"
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
      config.logger
    end

    private

    def config
      @config ||= Configure.new
    end
  end
end
