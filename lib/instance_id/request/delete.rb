require_relative '../response/delete'

module InstanceId
  class Request
    class Delete < self
      attr_accessor :registration_token

      def endpoint
        "/v1/web/iid/#{registration_token}"
      end

      def method
        :delete
      end

      def response_class
        InstanceId::Response::Delete
      end

      def invoke
        raise "invalid token! #{registration_token}" unless /\A.+\z/ === registration_token
        super
      end
    end
  end
end
