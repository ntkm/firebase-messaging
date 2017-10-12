require 'spec_helper'

module InstanceId
  RSpec.describe Response do
    let(:response) { described_class.new(status: status, body: body, headers: headers) }
    let(:status) { 200 }
    let(:body) { "{}" }
    let(:headers) { {} }

    describe '#success?' do
      subject { response.success? }

      context 'when status < 200' do
        let(:status) { rand(1...200).to_s }

        it { is_expected.to be_falsey }
      end

      context 'when status >= 400' do
        let(:status) { rand(400...700).to_s }

        it { is_expected.to be_falsey }
      end


      context 'when status is in the range from 200 to 399' do
        let(:status) { rand(200..399).to_s }

        it { is_expected.to be_truthy }
      end
    end

    describe '#failure?' do
      subject { response.failure? }

      before { allow(response).to receive(:success?).and_return success }

      context 'when success' do
        let(:success) { true }

        it { is_expected.to be_falsey }
      end

      context 'when not success' do
        let(:success) { false }

        it { is_expected.to be_truthy }
      end
    end

    describe '#errors' do
      subject { response.errors }

      context 'when body is valid JSON containing no error' do
        let(:body) { "{}" }

        it { is_expected.to eq [] }
      end

      context 'when body is valid JSON but includes key "error"' do
        let(:body) { "{\"error\" : \"e\"}" }

        it { is_expected.to all(match(error: String)) }
      end

      context 'when body is malformed JSON' do
        let(:body) { "{ [ }" }

        it { is_expected.to all(match(error: 'JSON::ParserError')) }
      end
    end

    describe '#body_json' do
      subject { response.body_json }

      context 'when body is valid JSON containing no error' do
        let(:body) { { 'keys' => %w(b c gg) }.to_json }

        it { is_expected.to eq JSON.parse(body, symbolize_names: true) }
      end

      context 'when body is valid JSON but includes key "error"' do
        let(:body) { "{\"error\" : \"e\"}" }

        it { is_expected.to be_nil }
      end

      context 'when body is malformed JSON' do
        let(:body) { "{ [ }" }

        it { is_expected.to be_nil }
      end

    end
  end
end
