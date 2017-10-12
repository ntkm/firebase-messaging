require 'json'
require 'active_support/all'

module InstanceId
  class Response
    attr_reader :status
    attr_reader :body
    attr_reader :headers

    def initialize(status:, body: nil, headers: nil)
      @status  = status.to_i
      @body    = body
      @headers = headers
    end

    def success?
      @status.in? 200...400
    end

    def failure?
      !success?
    end

    def body_json
      parse_body.tap do |json|
        break json.key?(:error) ? nil : json
      end
    end

    def errors
      parse_body.tap do |json|
        break json.key?(:error) ? [json.slice(:error)] : []
      end
    end

    private

    def parse_body
      JSON.parse(@body, symbolize_names: true)
    rescue JSON::ParserError => e
      { error: e.class.to_s }
    end
  end
end
