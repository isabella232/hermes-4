module FakeAuthentication
  def login
    let!(:login_user) { FactoryGirl.create :user }

    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]

      sign_in login_user
    end
  end
end
