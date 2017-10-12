require 'spec_helper'

describe Firebase::Messaging do
  describe 'logger' do
    subject { Firebase::Messaging.logger }

    describe 'default logger' do
      it { is_expected.to be_a Firebase::Messaging::Logger }
      it { expect(subject.logger).to be_a Logger }
    end

    describe 'customized logger' do
      before { Firebase::Messaging.configure { |config| config.logger = ActiveSupport::Logger.new(STDOUT) } }

      it { is_expected.to be_a Firebase::Messaging::Logger }
      it { expect(subject.logger).to be_a ActiveSupport::Logger }
    end
  end
end
