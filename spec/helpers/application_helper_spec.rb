# -*- encoding: utf-8 -*-

require 'rails_helper'

describe ApplicationHelper do

  describe '#logo' do
    it 'works' do
      expect(helper.logo).to include(root_path)
      expect(helper.logo).to include('id="logo"')
      expect(helper.logo).to include('class="navbar-brand"')

      expect(helper.logo).to include('hermes-logo.png')
      expect(helper.logo).to include('width="22"')
      expect(helper.logo).to include('height="22"')

      expect(helper.logo).to include('Hermes')
      expect(helper.logo).to include('class="hermes-title"')
    end
  end

  describe '#gravatar' do
    let!(:email) { Faker::Internet.email(Faker::Name.name) }
    let!(:size) { 'medium' }

    it 'works' do
      expect(Digest::MD5).to receive(:hexdigest).and_return('foo').exactly(4).times

      expect(helper.gravatar email, size).to include('gravatar.com/avatar')
      expect(helper.gravatar email, size).to include("size=#{size}")
      expect(helper.gravatar email, size).to include('foo')
      expect(helper.gravatar email, size).to include('default=identicon')
    end
  end

  describe '#logo_big' do
    it 'works' do
      expect(helper.logo_big).to include('hermes-logo.png')
      expect(helper.logo_big).to include('class="logo"')
      expect(helper.logo_big).to include('width="35"')
      expect(helper.logo_big).to include('height="33"')
    end
  end

  describe '#hermes_embed_url' do
    it 'works' do
      expect(helper.hermes_embed_url).to include(root_url)
      expect(helper.hermes_embed_url).to include('assets/hermes.js')
    end
  end

  describe '#any_sites?' do
    let!(:site) { FactoryGirl.create(:site) }

    it 'works' do
      expect(helper).to receive(:current_user).and_return(site.user)
      expect(helper.any_sites?).to be true

      assign(:any_sites, false)
      expect(helper).to receive(:current_user).and_return(FactoryGirl.create :user)
      expect(helper.any_sites?).to be false
    end

    it 'with sites' do
      assign(:any_sites, true)
      expect(helper.any_sites?).to be true
    end
  end

end
