require 'spec_helper'

module InstanceId
  class Request
    RSpec.describe BatchOperation do
      let(:request) { described_class.new }
      let(:registration_tokens) { %w(a b c) }
      let(:status) { 200 }
      let(:endpoint) { "/iid/v1:batch#{operation_type.to_s.camelize}" }
      let(:method) { :post }
      let(:topic) { '/topics/all' }
      let(:operation_type) { InstanceId::Request::BatchOperation::OPERATION_TYPE_ADD }
      let(:response) do
        {
          "results" => [
            {},
            {"error" => "NOT_FOUND"},
            {},
          ]
        }
      end

      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
            stub.send(method, endpoint) { |_env| [status, {}, response.to_json] }
          end
        end
      end

      before do
        allow(Faraday).to receive(:new).and_return(stub_connection)

        request.registration_tokens = registration_tokens
        request.topic               = topic
        request.operation_type      = operation_type
      end

      describe '#method' do
        subject { request.method }

        it { is_expected.to eq method }
      end

      describe '#endpoint' do
        subject { request.endpoint }

        it { is_expected.to eq endpoint }
      end

      describe '#response_class' do
        subject { request.response_class }

        it { is_expected.to eq InstanceId::Response::BatchOperation }
      end

      describe '#invoke' do
        subject { request.invoke }

        context 'with malformed topic' do
          let(:topic) { '/topi9/all' }

          it { expect { subject }.to raise_error /invalid/ }
        end
      end
    end
  end
end
