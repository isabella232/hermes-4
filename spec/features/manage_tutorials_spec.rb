require 'rails_helper'

feature "Manage tutorials", type: :feature do
  let!(:login_user) { login }
  let!(:site) { FactoryGirl.create :site, user: login_user }

  scenario 'new tutorial button' do
    visit root_path

    expect(page).to have_content(site.name)
    expect(page).to have_content(site.name)
    expect(page).to have_link("0 tutorial", site_tutorials_path(site))
    expect(page).to have_link("new", new_site_tutorial_path(site))
  end

  scenario 'site tutorials pagen' do
    tutorial = FactoryGirl.create :tutorial, site: site

    visit site_tutorials_path(site)

    expect(page).to have_content('All tutorials')
    expect(page).to have_link("New Tutorial", new_site_tutorial_path(site))
  end

  scenario 'new tutorial form', :js do
    visit new_site_tutorial_path(site)

    expect(page).to have_link("Your sites")

    within('form.new_tutorial') do
      expect(page).to have_css('#tutorial_title')
      expect(page).to have_css('#tutorial_welcome_message', visible: false)
      expect(page).to have_css('.textarea-editable')
      expect(page).to have_css('#tutorial_path')
      expect(page).to have_css('#tutorial_path_re')
      expect(page).to have_css('#tutorial_overlay')
      expect(page).to have_css('#tutorial_progress_bar')
      expect(page).to have_css('#tutorial_published_at')
      expect(page).to have_css('#tutorial_unpublished_at')
      expect(page).to have_css('button', text: 'Create')
    end
  end

  scenario 'show tutorial page', :js do
    tutorial = FactoryGirl.create :tutorial, site: site

    visit site_tutorial_path(site, tutorial)

    expect(page).to have_content(tutorial.title)
    expect(page).to have_content(tutorial.path)
    expect(page).to have_content(I18n.l tutorial.published_at)
    expect(page).to have_content(I18n.l tutorial.unpublished_at)

    expect(page).to have_link('edit', edit_site_tutorial_path(site, tutorial))
    expect(page).to have_link('delete', site_tutorial_path(site, tutorial))

    expect(page).to have_link('Add a message to your tutorial')
  end

  scenario 'edit tutorial page', :js do
    tutorial = FactoryGirl.create :tutorial, site: site

    visit edit_site_tutorial_path(site, tutorial)

    within('form.edit_tutorial') do
      expect(page).to have_css('#tutorial_title')
      expect(page).to have_css('#tutorial_welcome_message', visible: false)
      expect(page).to have_css('.textarea-editable')
      expect(page).to have_css('#tutorial_path')
      expect(page).to have_css('#tutorial_path_re')
      expect(page).to have_css('#tutorial_overlay')
      expect(page).to have_css('#tutorial_progress_bar')
      expect(page).to have_css('#tutorial_published_at')
      expect(page).to have_css('#tutorial_unpublished_at')
      expect(page).to have_css('button', text: 'Update')
    end
  end
end
