require 'spec_helper'

describe Firebase::Messaging::Request::For do
  describe '.new' do
    subject { Firebase::Messaging::Request::For.new(to) }

    context 'string direction' do
      let(:to) { 'token' }

      it { expect(subject.to).to eq to }
    end

    context 'string directions' do
      let(:to) { %w(token1 token2) }

      it { expect(subject.registration_ids).to eq to }
    end

    context 'array direction with one item' do
      let(:to) { ['/topics/all'] }

      it { expect(subject.to).to eq to.first }
    end

    context 'array direction with items' do
      let(:to) { ['/topics/ios', '/topics/android'] }

      it { expect(subject.topics).to eq to }
    end

    context 'array direction with nested items(or topic)' do
      let(:to) { [['/topics/ios', '/topics/android']] }

      it { expect(subject.topics).to eq to }
    end
  end

  describe '#payload' do
    subject { Firebase::Messaging::Request::For.new(to).payload }

    context '@to' do
      let(:to) { 'token' }

      it { is_expected.to eq(to: to) }
    end

    context '@registration_ids' do
      let(:to) { %w(token1 token2) }

      it { is_expected.to eq(registration_ids: to) }
    end

    context 'and topic' do
      let(:to) { ['/topics/ios', '/topics/android'] }

      it { is_expected.to eq(condition: "'ios' in topics && 'android' in topics") }
    end

    context 'or topic' do
      let(:to) { [['/topics/dogs', '/topics/cats'], '/topics/birds'] }

      it { is_expected.to eq(condition: "('dogs' in topics || 'cats' in topics) && 'birds' in topics") }
    end
  end

  describe '#type' do
    subject { Firebase::Messaging::Request::For.new(to).type }

    context 'down_stream_http_message' do
      let(:to) { 'token' }

      it { is_expected.to eq :down_stream_http_message }
    end

    context 'down_stream_http_message by registration_ids' do
      let(:to) { %w(token1 token2) }

      it { is_expected.to eq :down_stream_http_message }
    end

    context 'topic_message with single topic' do
      let(:to) { ['/topics/all'] }

      it { is_expected.to eq :topic_message }
    end

    context 'topic_message' do
      let(:to) { [['/topics/dogs', '/topics/cats'], '/topics/birds'] }

      it { is_expected.to eq :topic_message }
    end
  end
end
