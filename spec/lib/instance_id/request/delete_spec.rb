require 'spec_helper'

module InstanceId
  class Request
    RSpec.describe Delete do
      let(:request) { described_class.new }
      let(:registration_token) { 'token' }
      let(:status) { 204 }
      let(:endpoint) { "/v1/web/iid/#{registration_token}" }
      let(:method) { :delete }
      let(:response) { '' }

      let(:stub_connection) do
        Faraday.new do |builder|
          builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
            stub.send(method, endpoint) { |_env| [status, {}, response.to_json] }
          end
        end
      end

      before do
        allow(Faraday).to receive(:new).and_return(stub_connection)

        request.registration_token = registration_token
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

        it { is_expected.to eq InstanceId::Response::Delete }
      end

      describe '#invoke' do
        subject { request.invoke }

        context 'when registration_token is invalid format' do
          let(:registration_token) { "\n" }

          it { expect { subject }.to raise_error /invalid/ }
        end
      end
    end
  end
end
