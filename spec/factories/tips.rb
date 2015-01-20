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
      ignore do
        site nil
      end

      after :build do |tip, e|
        tip.tippable = e.site.presence || FactoryGirl.create(:site)
      end
    end

    trait :unpublished do
      after :build do |tip, _|
        tip.published_at   = 20.days.ago
        tip.unpublished_at = 10.days.ago
      end
    end

    trait :noselector do
      after :build do |tip, _|
        tip.selector = ''
      end
    end

    factory :tip_noselector,    traits: [ :noselector  ]
    factory :tip_with_tutorial, traits: [ :tutorial    ]
    factory :tip_with_site,     traits: [ :site        ]
    factory :tip_unpublished,   traits: [ :unpublished ]
  end
end
