require 'rails_helper'

feature "Manage tutorial tips", type: :feature do
  let!(:login_user) { login }
  let!(:site) { FactoryGirl.create :site, user: login_user }
  let!(:tutorial) { FactoryGirl.create :tutorial, site: site }

  scenario 'new tip button' do
    visit site_tutorial_path(site, tutorial)

    expect(page).to have_link("Add a message to your tutorial!", new_tutorial_tip_path(tutorial))
  end

  scenario 'tutorial tips page' do
    tip = FactoryGirl.create :tip, tippable: tutorial

    visit tutorial_tips_path(tutorial)

    expect(page).to have_content('All tips')
    expect(page).to have_link("New tip", new_tutorial_tip_path(tutorial))
  end

  scenario 'new tip form', :js do
    visit new_tutorial_tip_path(tutorial)

    within('form.new_tip') do
      expect(page).to have_css('#tip_title')
      expect(page).to have_css('#tip_content', visible: false)
      expect(page).to have_css('.textarea-editable')
      expect(page).to have_css('#tip_path')
      expect(page).to have_css('#absolute_url')
      expect(page).to have_css('button', text: 'Create')
    end
  end

  scenario 'edit tutorial page', :js do
    tip = FactoryGirl.create :tip, tippable: tutorial

    visit edit_tutorial_tip_path(tutorial, tip)

    within('form.edit_tip') do
      expect(page).to have_css('#tip_title')
      expect(page).to have_css('#tip_content', visible: false)
      expect(page).to have_css('.textarea-editable')
      expect(page).to have_css('#tip_path')
      expect(page).to have_css('#absolute_url')
      expect(page).to have_css('button', text: 'Update')
    end
  end
end
