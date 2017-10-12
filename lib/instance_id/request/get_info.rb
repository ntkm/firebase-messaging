require_relative '../request'
require_relative '../response/get_info'

module InstanceId
  class Request
    class GetInfo < self
      attr_accessor :including_details
      attr_accessor :registration_token

      alias_method :including_details?, :including_details

      def invoke
        raise "invalid registration_token! #{registration_token}" unless /\A.+\z/ === registration_token
        super do |request|
          request.params['details'] = !!including_details ? 'true' : 'false'
        end
      end

      def endpoint
        "/iid/info/#{registration_token}"
      end

      def method
        :get
      end

      def response_class
        InstanceId::Response::GetInfo
      end
    end
  end
end
