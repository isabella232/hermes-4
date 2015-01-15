FactoryGirl.define do
  factory :tutorial do
    site
    title "MyString"
    published_at "2015-01-15 18:07:32"
    unpublished_at "2015-01-15 18:07:32"
    path "MyString"
    selector "MyText"
    welcome_message "MyText"
    overlay false
    progress_bar false
    path_re "MyString"
  end

end
