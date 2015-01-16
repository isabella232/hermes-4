FactoryGirl.define do
  factory :site do
    user
    name { Faker::Internet.domain_word }
    hostname { Faker::Internet.domain_name }
    description { Faker::Lorem.sentence 10 }
    verification_token "MyString"
    verified_at { 10.days.ago }
    protocol "http"
  end

end
