FactoryGirl.define do
  factory :tip do
    title { Faker::Lorem.word }
    content { Faker::Lorem.sentence 10 }
    published_at { 10.days.ago }

    trait :tutorial do
      after :build do |tip, _|
        tip.tippable      = FactoryGirl.create(:tutorial)
      end
    end

    trait :site do
      after :build do |tip, _|
        tip.tippable      = FactoryGirl.create(:site)
      end
    end

    trait :unpublished do
      after :build do |tip, _|
        tip.published_at   = 20.days.ago
        tip.unpublished_at = 10.days.ago
      end
    end

    factory :tip_with_tutorial, traits: [ :tutorial    ]
    factory :tip_with_site,     traits: [ :site        ]
    factory :tip_unpublished,   traits: [ :unpublished ]
  end
end
