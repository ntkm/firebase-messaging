$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'firebase/messaging'
require 'instance_id'

require 'pry'

RSpec.configure do |config|
  RSpec::Expectations.configuration.on_potential_false_positives = :nothing

  config.before do
    Firebase::Messaging.configure do |config|
      config.logger = Logger.new(STDOUT)
      config.logger_level = :fatal # testなのでログは出力しない
    end
  end
end
