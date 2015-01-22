require 'rails_helper'

feature "Manage site tips", type: :feature do
  let!(:login_user) { login }
  let!(:site) { FactoryGirl.create :site, user: login_user }

  scenario 'new tip button' do
    visit site_path(site)

    expect(page).to have_link("New Tip", new_site_tip_path(site))
  end

  scenario 'site tips page' do
    tip = FactoryGirl.create :tip, tippable: site

    visit site_tips_path(site)

    expect(page).to have_content('All tips')
    expect(page).to have_link("New tip", new_site_tip_path(site))
  end

  scenario 'new tip form', :js do
    visit new_site_tip_path(site)

    within('form.new_tip') do
      expect(page).to have_css('#tip_title')
      expect(page).to have_css('#tip_content', visible: false)
      expect(page).to have_css('.textarea-editable')
      expect(page).to have_css('#tip_path')
      expect(page).to have_css('button', text: 'Create')
    end
  end

  scenario 'edit tutorial page', :js do
    tip = FactoryGirl.create :tip, tippable: site

    visit edit_site_tip_path(site, tip)

    within('form.edit_tip') do
      expect(page).to have_css('#tip_title')
      expect(page).to have_css('#tip_content', visible: false)
      expect(page).to have_css('.textarea-editable')
      expect(page).to have_css('#tip_path')
      expect(page).to have_css('button', text: 'Update')
    end
  end
end
