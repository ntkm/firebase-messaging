require 'spec_helper'

module InstanceId
  RSpec.describe Client do
    let(:client) { described_class.new }

    describe '#get_info' do
      subject { client.get_info(registration_token, including_details) }

      let(:registration_token) { 'aaaaaa' }
      let(:including_details) { false }
      let(:status) { 200 }
      let(:response_body) do
        {
          "application" => "com.iid.example",
          "authorizedEntity" => "123456782354",
          "platform" => "Android",
          "attestStatus" => "ROOTED",
          "appSigner" => "1a2bc3d4e5"
        }
      end
      let(:response) { InstanceId::Response::GetInfo.new(status: status, body: response_body.to_json, headers: {}) }

      before do
        allow_any_instance_of(InstanceId::Request::GetInfo).to receive(:invoke).and_return(response)
      end

      it { is_expected.to be_an InstanceId::Response::GetInfo }
    end

    describe '#delete' do
      subject { client.delete(registration_token) }

      let(:registration_token) { 'aaaaaa' }
      let(:status) { 204 }
      let(:response_body) { '' }
      let(:response) { InstanceId::Response::Delete.new(status: status, body: response_body.to_json, headers: {}) }

      before do
        allow_any_instance_of(InstanceId::Request::Delete).to receive(:invoke).and_return(response)
      end

      it { is_expected.to be_an InstanceId::Response::Delete }
    end

    describe '#batch_operation' do
      subject { client.batch_operation(operation_type, topic, registration_tokens) }

      let(:operation_type) { InstanceId::Request::BatchOperation::OPERATION_TYPE_ADD }
      let(:registration_tokens) { %w(a b c) }
      let(:topic) { '/topics/all' }
      let(:status) { 200 }
      let(:response_body) do
        {
          "results" => [
            {},
            {"error" =>"NOT_FOUND"},
            {},
          ]
        }
      end
      let(:response) { InstanceId::Response::BatchOperation.new(status: status, body: response_body.to_json, headers: {}) }

      before do
        allow_any_instance_of(InstanceId::Request::BatchOperation).to receive(:invoke).and_return(response)
      end

      it { is_expected.to be_an InstanceId::Response::BatchOperation }
    end
  end
end
