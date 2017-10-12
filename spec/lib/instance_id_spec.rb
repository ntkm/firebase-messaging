require 'spec_helper'

RSpec.describe InstanceId do
  describe 'logger' do
    subject{ described_class.logger }

    describe 'default logger' do
      it { is_expected.to be_a Logger }
    end

    describe 'customized logger' do
      before { described_class.configure { |config| config.logger = ActiveSupport::Logger.new(STDOUT) } }

      it { is_expected.to be_a ActiveSupport::Logger }
    end
  end
end
