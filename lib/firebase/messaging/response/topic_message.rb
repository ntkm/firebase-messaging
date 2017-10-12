require_relative '../response'

module Firebase
  module Messaging
    class Response
      class TopicMessage < Firebase::Messaging::Response
        def success?
          super && !!parsed_body[:message_id]
        end
      end
    end
  end
end
