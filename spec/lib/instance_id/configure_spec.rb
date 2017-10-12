require 'spec_helper'

module InstanceId
  RSpec.describe Configure do
    let(:instance) { described_class.new }
    let(:server_key) { 'uv983qioe22' }

    before do
      instance.server_key = server_key
    end

    describe '#headers' do
      subject { instance.headers }

      it do
        is_expected.to match(
          'Authorization' => match(/\Akey=#{server_key}\z/),
          'Content-Type' => 'application/json'
        )
      end
    end
  end
end
