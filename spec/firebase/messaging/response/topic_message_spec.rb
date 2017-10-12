require 'spec_helper'

describe Firebase::Messaging::Response::TopicMessage do
  let(:to) { '/topics/foo-bar' }
  let(:status) { 200 }
  let(:response) { '' }
  let(:response_object) do
    Firebase::Messaging::Client.new.send do |req|
      req.to = to
    end
  end
  let(:stub_connection) do
    Faraday.new do |builder|
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post('/') { |_env| [status, {}, response.to_json] }
      end
    end
  end
  before do
    allow(Faraday).to receive(:new).and_return(stub_connection)
  end

  describe '#success?' do
    subject { response_object.success? }

    context 'Successful' do
      let(:response) do
        {
          message_id: '1023456'
        }
      end

      it { is_expected.to be_truthy }
    end

    context 'Status 401' do
      let(:status) { 401 }
      let(:response) do
        {
          error: 'Unauthorized'
        }
      end

      it { is_expected.to be_falsey }
    end

    context '200 & Failure message' do
      let(:response) do
        {
          error: 'TopicsMessageRateExceeded'
        }
      end

      it { is_expected.to be_falsey }
    end
  end

  describe '#errors' do
    subject { response_object.errors }

    context 'Not successful' do
      let(:response) do
        {
          error: 'TopicsMessageRateExceeded'
        }
      end

      it do
        is_expected.to eq [
          { error: 'TopicsMessageRateExceeded' }
        ]
      end
    end

    context 'Json parse error' do
      let(:response) { '' }

      it { expect { subject }.to raise_error(Firebase::Messaging::UnexpectedResponseError) }
    end
  end
end
