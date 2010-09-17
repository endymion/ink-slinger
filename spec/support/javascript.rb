RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
    Brand.configuration = YAML::load_file('spec/models/brands_test.yml')
    Brand.seed
  end

  # These are necessary because RSpec::Core will call the before hook twice.
  @@before_already = {}
  @@after_already = {}
  
  config.before(:each) do
    unless @@before_already[example.description] || example.metadata[:noclean]
      @@before_already[example.description] = true
      
      if example.metadata[:js]
        Capybara.current_driver = :selenium
        DatabaseCleaner.strategy = :truncation, {:except => %w[brands]}
      else
        DatabaseCleaner.strategy = :transaction
        DatabaseCleaner.start
      end
    end
  end

  config.after(:each) do
    unless @@after_already[example.description] || example.metadata[:noclean]
      @@after_already[example.description] = true

      Capybara.use_default_driver if example.metadata[:js]
      DatabaseCleaner.clean
    end
  end
end