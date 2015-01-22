require 'rails_helper'

feature "Manage sites", type: :feature do
  let!(:login_user) { login }

  scenario 'new site button when there are no other sites' do
    visit root_path

    expect(page).to     have_link("Add new site")
    expect(page).not_to have_link("New site")
  end

  scenario 'new site button when there are other sites' do
    FactoryGirl.create(:site, user: login_user)

    visit root_path

    expect(page).to have_link("Add new site")
    expect(page).to have_link("New site")
  end

  scenario 'new site form', :js do
    visit root_path

    find_link('Add new site').click

    expect(page.find 'h4', text: 'Add a new site').to be_visible

    within('form.new_site') do
      expect(page.find '#site_name').to               be_visible
      expect(page.find '#site_hostname').to           be_visible
      expect(page.find '#site_protocol').to           be_visible
      expect(page.find 'button', text: 'Add site').to be_visible
    end
  end

  scenario 'show site page', :js do
    site = FactoryGirl.create :site, user: login_user

    visit site_path(site)

    expect(page).to have_content(site.name)
    expect(page).to have_content(site.hostname)

    expect(page).to have_link('edit', edit_site_path(site))
    expect(page).to have_link('delete', site_path(site))

    expect(page).to have_link('New tutorial', new_site_tutorial_path(site))
    expect(page).to have_link('New Tip', new_site_tip_path(site))
  end

  scenario 'edit site page', :js do
    site = FactoryGirl.create :site, user: login_user

    visit site_path(site)

    find_link('edit').click

    expect(page.find 'h4', text: 'Edit an existing site').to be_visible

    within('form.edit_site') do
      expect(page.find '#site_name').to               be_visible
      expect(page.find '#site_hostname').to           be_visible
      expect(page.find '#site_protocol').to           be_visible
      expect(page.find 'button', text: 'Update site').to be_visible
    end
  end
end
