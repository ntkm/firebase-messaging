require_relative 'request'

module Firebase
  module Messaging
    # send firebase notification
    #   Firebase::Messaging::Client.new.send do |req|
    #     req.body.notification = {title: "title", body: "body"}
    #     req.body.data         = {content: "abc"}
    #     req.priority          = :high # default: "high"
    #     req.to = ['/topics/A', '/topics/B'] # or "/topics/A" or "fcm-token"
    #   end
    class Client
      def send
        yield request
        @request.post
      end

      def request
        @request ||= Firebase::Messaging::Request.new
      end
    end
  end
end
