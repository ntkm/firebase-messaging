require 'spec_helper'

describe Firebase::Messaging::Response::DownStreamHttpMessage do
  let(:to) { 'token' }
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

    context 'All successful' do
      let(:response) do
        # https://firebase.google.com/docs/cloud-messaging/server
        {
          'multicast_id' => 108,
          'success' => 1,
          'failure' => 0,
          'canonical_ids' => 0,
          'results' => [
            { 'message_id' => '1:08' }
          ]
        }
      end

      it { is_expected.to be_truthy }
    end

    context 'Part of successful' do
      let(:response) do
        {
          'multicast_id' => 216,
          'success' => 3,
          'failure' => 3,
          'canonical_ids' => 1,
          'results' => [
            { 'message_id' => '1:0408' },
            { 'error' => 'Unavailable' },
            { 'error' => 'InvalidRegistration' },
            { 'message_id' => '1:1516' },
            { 'message_id' => '1:2342', 'registration_id' => '32' },
            { 'error' => 'NotRegistered' }
          ]
        }
      end

      it { is_expected.to be_truthy }
    end

    context 'Not successful' do
      let(:response) do
        {
          'multicast_id' => 108,
          'success' => 0,
          'failure' => 1,
          'canonical_ids' => 0,
          'results' => [
            { 'error' => 'NotRegistered' }
          ]
        }
      end

      it { is_expected.to be_falsey }
    end

    context '401 error' do
      let(:status) { 401 }
      let(:response) do
        {
          error: 'Unauthorized'
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
          'multicast_id' => 216,
          'success' => 3,
          'failure' => 3,
          'canonical_ids' => 1,
          'results' => [
            { 'message_id' => '1:0408' },
            { 'error' => 'Unavailable' },
            { 'error' => 'InvalidRegistration' },
            { 'message_id' => '1:1516' },
            { 'message_id' => '1:2342', 'registration_id' => '32' },
            { 'error' => 'NotRegistered' }
          ]
        }
      end

      it do
        is_expected.to eq [
          { error: 'Unavailable' },
          { error: 'InvalidRegistration' },
          { error: 'NotRegistered' }
        ]
      end
    end

    context 'Not successful by Device group name' do
      let(:response) do
        {
          'success' => 1,
          'failure' => 2,
          'failed_registration_ids' => %w(
            regId1
            regId2
          )
        }
      end

      it do
        is_expected.to eq [
          { error: 'regId1' },
          { error: 'regId2' }
        ]
      end
    end

    context 'Json parse error' do
      let(:response) { '' }

      it { expect { subject }.to raise_error(Firebase::Messaging::UnexpectedResponseError) }
    end
  end
end
