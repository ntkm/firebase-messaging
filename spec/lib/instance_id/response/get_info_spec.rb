require 'spec_helper'

module InstanceId
  class Response
    RSpec.describe GetInfo do
      subject { described_class }

      it { expect(subject.ancestors).to include InstanceId::Response }
    end
  end
end
