module InstanceId
  class Request
    def initialize(*args, **options)
      yield(connector) if block_given?
    end

    def invoke
      response = connector.send(method, endpoint) do |request|
        yield(request) if block_given?
      end
      parse response
    end

    def endpoint
      raise NotImplementedError, "concrete classes should implement #{__method__}."
    end

    def method
      raise NotImplementedError, "concrete classes should implement #{__method__}, returning one of #{%i(get post put patch delete)}."
    end

    def response_class
      raise NotImplementedError, "concrete classes should implement #{__method__}, returning concrete class of InstanceId::Response"
    end

    private

    def parse(response)
      response_class.new(status: response.status, body: response.body, headers: response.headers)
    end

    def connector
      @connector ||= Faraday.new(url: InstanceId.configure.base_url, headers: InstanceId.configure.headers) do |faraday|
        faraday.request :url_encoded            # form-encode POST params
        faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
        faraday.response :logger                # log requests to STDOUT
        faraday.use :instrumentation
      end
    end
  end
end
