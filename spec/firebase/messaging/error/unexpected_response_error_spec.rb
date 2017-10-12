require 'spec_helper'

describe Firebase::Messaging::UnexpectedResponseError do
  let(:to) { 'token' }
  let(:status) { 500 }
  let(:response) do
    <<HTML
<HTML>
<HEAD>
<TITLE>Invalid (legacy) Server-key delivered or Sender is not authorized to perform request.</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF" TEXT="#000000">
<H1>Invalid (legacy) Server-key delivered or Sender is not authorized to perform request.</H1>
<H2>Error 401</H2>
</BODY>
</HTML>
HTML
  end
  let(:response_object) do
    Firebase::Messaging::Client.new.send do |req|
      req.to = to
    end
  end
  let(:stub_connection) do
    Faraday.new do |builder|
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.post('/') { |_env| [status, {}, response] }
      end
    end
  end
  before do
    allow(Faraday).to receive(:new).and_return(stub_connection)
  end

  describe 'jsonのレスポンスが取得できない場合' do
    it { expect { response_object }.to raise_error(Firebase::Messaging::UnexpectedResponseError) }
  end
end
