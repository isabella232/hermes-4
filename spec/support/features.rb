module Features
  RSpec.configure do |config|
    config.include SessionHelpers, type: :feature
  end
end
