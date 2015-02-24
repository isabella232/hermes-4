module Features
  autoload :SessionHelpers, 'support/features/session_helpers'

  RSpec.configure do |config|
    config.include SessionHelpers, type: :feature
  end
end
