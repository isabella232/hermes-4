require 'rails_helper'

feature "Create sites", type: :feature do
  scenario 'foo' do
    sign_up_with Faker::Internet.email(Faker::Name.name), 'foobar123'
  end

  scenario 'bar' do
    sign_in
  end
end
