require_relative 'request/body'
require_relative 'request/for'
require_relative 'response'
require_relative 'logger'

module Firebase
  module Messaging
    class Request
      attr_reader :body
      attr_accessor :priority

      def initialize
        @connector = Faraday.new(url: Firebase::Messaging.configure.base_url, headers: Firebase::Messaging.configure.headers) do |faraday|
          faraday.request :url_encoded # form-encode POST params
          faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
          faraday.response :logger # log requests to STDOUT
          faraday.use :instrumentation
        end
        @body = Body.new
        @priority = :high
      end

      def to=(push_for)
        @for = Firebase::Messaging::Request::For.new(push_for)
      end

      def to
        @for
      end

      def type
        @for.type
      end

      def post
        Firebase::Messaging.logger.debug("Request. body: #{build_body}")
        res = @connector.post do |req|
          req.body = build_body
        end
        Firebase::Messaging::Response.bind(type, status: res.status, body: res.body, headers: res.headers).tap do |response|
          log_level = response.success? ? :info : :warn
          Firebase::Messaging.logger.send(log_level, "Response. status: #{res.status}, body: #{res.body}")
        end
      end

      private

      def build_body
        { priority: @priority }.merge(@for.payload).merge(@body.payload).to_json
      end
    end
  end
end
