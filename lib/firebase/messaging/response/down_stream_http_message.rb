require_relative '../response'

module Firebase
  module Messaging
    class Response
      class DownStreamHttpMessage < Firebase::Messaging::Response
        def success?
          super && parsed_body[:success] > 0
        end

        def errors
          if parsed_body.key? :results
            parsed_body[:results].select { |msg| msg[:error] }
          elsif parsed_body.key? :failed_registration_ids
            parsed_body[:failed_registration_ids].map { |id| { error: id } }
          else
            super
          end
        end
      end
    end
  end
end
