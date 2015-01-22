module Features
  RSpec.configure do |config|
    config.include Features::SessionHelpers, type: :feature
    config.include ShowMeTheCookies,         type: :feature
  end
end
