require_relative '../request'
require_relative '../response/batch_operation'

module InstanceId
  class Request
    class BatchOperation < self
      attr_accessor :operation_type
      attr_accessor :topic
      attr_accessor :registration_tokens

      OPERATION_TYPE_ADD    = 'add'.freeze
      OPERATION_TYPE_REMOVE = 'remove'.freeze

      def method
        :post
      end

      def endpoint
        "/iid/v1:#{operation_name}"
      end

      def response_class
        InstanceId::Response::BatchOperation
      end

      def invoke
        super do |request|
          request.params['to']                  = to
          request.params["registration_tokens"] = [registration_tokens].flatten.compact
        end
      end

      private

      def to
        raise "invalid topic format: #{topic}" unless /\A\/topics\/.+\z/ === topic
        topic
      end

      def operation_name
        case operation_type.to_s.downcase
        when OPERATION_TYPE_ADD    then 'batchAdd'
        when OPERATION_TYPE_REMOVE then 'batchRemove'
        else raise "operation not specified, operation_type = #{operation_type}"
        end
      end
    end
  end
end
