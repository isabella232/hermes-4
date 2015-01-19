FactoryGirl.define do
  factory :state do
    show_at { 10.minutes.ago }
    remote_user "MyString"

    trait :tip do
      after :build do |state, _|
        state.message      = FactoryGirl.create(:tip_with_tutorial)
      end
    end

    trait :tutorial do
      after :build do |state, _|
        state.message      = FactoryGirl.create(:tutorial)
      end
    end

    factory :state_with_tip,      traits: [ :tip ]
    factory :state_with_tutorial, traits: [ :tutorial ]
  end

end
