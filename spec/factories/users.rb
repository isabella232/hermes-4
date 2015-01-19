FactoryGirl.define do
  factory :user do
    full_name { Faker::Name.name }
    password "MyString"
    password_confirmation "MyString"

    after :build do |user, _|
      user.password_confirmation = user.password_confirmation.presence || user.password
      user.email = user.email.presence || Faker::Internet.email(user.full_name)
    end
  end

end
