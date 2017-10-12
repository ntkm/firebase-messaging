require 'spec_helper'

module InstanceId
  class Request
    RSpec.describe GetInfo do
      let(:request) { described_class.new }
      let(:registration_token) { 'aaaaaa' }
      let(:including_details) { false }
      let(:status) { 200 }
      let(:endpoint) { "/iid/info/#{registration_token}" }
      let(:method) { :get }
      let(:summary) do
        {
          "application" => "com.iid.example",
          "authorizedEntity" => "123456782354",
          "platform" => "Android",
          "attestStatus" => "ROOTED",
          "appSigner" => "1a2bc3d4e5"
        }
      end
      let(:response) { summary }
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

        it { is_expected.to eq endpoint  }
      end

      describe '#response_class' do
        subject { request.response_class }

        it { is_expected.to eq InstanceId::Response::GetInfo }
      end

      describe '#invoke' do
        subject { request.invoke }


        context 'when registration_token is invalid format' do
          let(:registration_token) { "\n" }

          it { expect { subject }.to raise_error /invalid/ }
        end

        context 'when including_details = true' do
          let(:including_details) { true }
          let(:details) do
            {
              "connectionType" => "WIFI",
              "connectDate" => "2015-05-12",
              "rel" => {
                "topics" => {
                  "topicname1" => {"addDate" => "2015-07-30"},
                  "topicname2" => {"addDate" => "2015-07-30"},
                  "topicname3" => {"addDate" => "2015-07-30"},
                  "topicname4" => {"addDate" => "2015-07-30"}
                }
              }
            }
          end
          let(:response) { summary.merge(details) }

          it { expect(subject.body_json).to include(details.deep_symbolize_keys) }
        end
      end
    end
  end
end
