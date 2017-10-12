require_relative 'response/down_stream_http_message'
require_relative 'response/topic_message'
require_relative 'error'
require 'json'
require 'active_support/all'

module Firebase
  module Messaging
    class Response
      attr_reader :status, :body, :headers

      def initialize(status: nil, body: nil, headers: nil)
        @status = status.to_i
        @body   = body
        @headers = headers
      end

      def success?
        status >= 200 && status < 400
      end

      def failure?
        !success?
      end

      def errors
        if parsed_body.key? :error
          [{ error: parsed_body[:error] }]
        else
          []
        end
      end

      def parsed_body
        @parsed_body ||= JSON.parse(body, symbolize_names: true)
      end

      class << self
        def json?(json)
          JSON.parse(json)
          true
        rescue JSON::ParserError
          false
        end

        def bind(type, status: nil, body: nil, headers: nil)
          if json?(body)
            "Firebase::Messaging::Response::#{type.to_s.classify}".constantize.new(status: status, body: body, headers: headers)
          else
            Firebase::Messaging.logger.error("Unexpected response. status: #{status}, body: #{body}")
            raise Firebase::Messaging::UnexpectedResponseError, { status: status, body: body, headers: headers }.to_s
          end
        end
      end
    end
  end
end
