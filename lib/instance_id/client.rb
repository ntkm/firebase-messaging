require_relative 'request/batch_operation'
require_relative 'request/delete'
require_relative 'request/get_info'

module InstanceId
  class Client
    def get_info(registration_token, including_details = false)
      InstanceId::Request::GetInfo.new.tap do |request|
        request.registration_token = registration_token
        request.including_details  = including_details
      end.invoke
    end

    def delete(registration_token)
      InstanceId::Request::Delete.new.tap do |request|
        request.registration_token = registration_token
      end.invoke
    end

    def batch_operation(operation_type, topic, registration_tokens)
      InstanceId::Request::BatchOperation.new.tap do |request|
        request.registration_tokens = registration_tokens
        request.topic               = topic
        request.operation_type      = operation_type
      end.invoke
    end
  end
end
