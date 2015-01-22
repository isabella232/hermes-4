module Controllers
  RSpec.configure do |config|
    config.include Devise::TestHelpers,             type: :controller
    config.extend  Controllers::FakeAuthentication, type: :controller
  end
end
