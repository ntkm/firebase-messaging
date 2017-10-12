require 'spec_helper'

module InstanceId
  RSpec.describe Request do
    let(:request) do
      Class.new(described_class) do
        def method
          :get
        end

        def endpoint
          '/'
        end

        def response_class
          InstanceId::Response
        end
      end.new
    end

    let(:stub_connection) do
      Faraday.new do |builder|
        builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get('/') { |_env| [200, {}, ''] }
        end
      end
    end

    before do
      allow(Faraday).to receive(:new).and_return(stub_connection)
    end

    describe '#invoke' do
      context 'given block' do
        it do
          expect { |block| request.invoke(&block) }.to yield_with_args(Faraday::Request)
        end
      end
    end
  end
end
