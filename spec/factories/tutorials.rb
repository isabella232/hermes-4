FactoryGirl.define do
  factory :tutorial do
    site
    title { Faker::Lorem.sentence }
    published_at { 10.days.ago }
    unpublished_at { 10.days.from_now}
    path "/"
    welcome_message { Faker::Lorem.paragraphs.join }
    overlay false
    progress_bar false
    selector '//body'

    trait :noselector do
      after :build do |tutorial, _|
        tutorial.selector = ''
      end
    end

    factory :tutorial_noselector, traits: [ :noselector ]
  end
end
