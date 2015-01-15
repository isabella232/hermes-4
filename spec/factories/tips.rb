FactoryGirl.define do
  factory :tip do
    tippable_id 1
    tippable_type "MyString"
    title "MyString"
    content "MyText"
    published_at "2015-01-15 18:05:53"
    unpublished_at "2015-01-15 18:05:53"
    selector "MyText"
    row_order 1
    path "MyString"
    site_host_ref "MyString"
    path_re "MyString"
  end

end
