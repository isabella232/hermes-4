FactoryGirl.define do
  factory :tip do
    title { Faker::Lorem.word }
    content { Faker::Lorem.sentence 10 }
    published_at { 10.days.ago }

    trait :tutorial do
      after :build do |tip, _|
        tip.tippable      = FactoryGirl.create(:tutorial)
        tip.tippable_type = 'Tutorial'
      end
    end

    trait :site do
      after :build do |tip, _|
        tip.tippable      = FactoryGirl.create(:site)
        tip.tippable_type = 'Site'
      end
    end

    factory :tip_with_tutorial, traits: [ :tutorial ]
    factory :tip_with_site,     traits: [ :site ]
  end

end
