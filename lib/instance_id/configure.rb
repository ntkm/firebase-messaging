module InstanceId
  class Configure
    attr_accessor :server_key
    attr_accessor :logger

    def initialize
      @server_key = ''
      @logger     = Logger.new(STDOUT)
    end

    def headers
      {
        'Authorization' => "key=#{@server_key}",
        'Content-Type'  => 'application/json'
      }
    end

    def base_url
      'https://iid.googleapis.com'
    end
  end
end
