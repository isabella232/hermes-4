module Controllers
  autoload :FakeAuthentication, 'support/controllers/fake_authentication.rb'

  RSpec.configure do |config|
    config.include Devise::TestHelpers, type: :controller
    config.extend  FakeAuthentication,  type: :controller
  end
end
