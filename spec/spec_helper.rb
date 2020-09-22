require 'database_cleaner'
require 'factory_bot'

RACK_ENV ||= 'test'
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

FactoryBot.definition_file_paths = [
    File.join(Padrino.root, 'spec', 'factories')
]
FactoryBot.find_definitions

RSpec.configure do |config|
  config.include Rack::Test::Methods
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end

def app(app = nil, &blk)
  @app ||= block_given? ? app.instance_eval(&blk) : app
  @app ||= Padrino.application
end
