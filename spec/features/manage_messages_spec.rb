require 'rails_helper'

feature "Manage messages", type: :feature do
  let!(:login_user)   { login }
  let!(:site)         { FactoryGirl.create :site, user: login_user }
  let!(:tutorial)     { FactoryGirl.create :tutorial, site: site }
  let!(:tutorial_tip) { FactoryGirl.create :tip, tippable: tutorial }
  let!(:site_tip)     { FactoryGirl.create :tip, tippable: site }

  let!(:params)       { {callback: 'http://foo.bar', site_ref: site.hostname, format: :js} }

  scenario 'index', driver: :with_referer do
    visit messages_path(params)

    expect(page).to have_content(site_tip.title)
    expect(page).to have_content(site_tip.content)
    expect(page).to have_content(site_tip.path)
  end

  scenario 'tutorial', driver: :with_referer do
    visit tutorial_messages_path(tutorial, params)

    expect(page).to have_content(tutorial_tip.title)
    expect(page).to have_content(tutorial_tip.content)
    expect(page).to have_content(tutorial_tip.path)
  end

  scenario 'tutorials', driver: :with_referer do
    visit tutorials_messages_path(params)

    expect(page).to have_content(tutorial_tip.title)
    expect(page).to have_content(tutorial_tip.content)
    expect(page).to have_content(tutorial_tip.path)
  end

  scenario 'show tutorial', driver: :with_referer do
    visit message_path(tutorial, params.merge(type: 'tutorial'))

    expect(page).to have_content(tutorial_tip.title)
    expect(page).to have_content(tutorial_tip.content)
    expect(page).to have_content(tutorial_tip.path)
  end

  scenario 'show site', driver: :with_referer do
    visit message_path(site_tip, params.merge(type: 'tip'))

    expect(page).to have_content(site_tip.title)
    expect(page).to have_content(site_tip.content)
    expect(page).to have_content(site_tip.path)
  end

  scenario 'update', driver: :with_referer do
    Capybara.reset_sessions!
    page.driver.browser.set_cookie("__hermes_user=foo")

    visit dismiss_message_path(tutorial, params.merge(type: 'Tutorial'))

    expect(page).to have_content('{}')
  end
end
