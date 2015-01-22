module Features
  module SessionHelpers
    include Warden::Test::Helpers
    Warden.test_mode!

    def login(user=nil)
      user ||= FactoryGirl.create(:user)

      login_as(user, scope: :user)

      return user
    end

    def logout(user=nil)
      user ||= FactoryGirl.stub(:user)

      logout(:user)

      return self
    end
  end
end

