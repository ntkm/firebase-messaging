module Firebase
  module Messaging
    class Configure
      attr_accessor :server_key
      attr_accessor :logger
      attr_accessor :logger_level

      def initialize
        @server_key = ''
        @logger = Logger.new(STDOUT)
        @logger_level = :warn
      end

      # TODO: separete on request namespace when more headers
      def headers
        {
          'Authorization' => "key=#{@server_key}",
          'Content-Type'  => 'application/json'
        }
      end

      def base_url
        'https://fcm.googleapis.com/fcm/send'
      end
    end
  end
end
