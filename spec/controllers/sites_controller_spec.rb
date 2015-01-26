# -*- encoding: utf-8 -*-

require 'rails_helper'

describe SitesController do
  login

  let!(:site) { FactoryGirl.create :site, user: login_user }

  describe '#index' do
    it 'works' do
      get :index

      expect(assigns(:sites)).to have(1).items
    end
  end

  describe '#show' do
    it 'works' do
      get :show, id: site.id

      expect(assigns(:site)).to eq(site)
    end
  end

  describe '#new' do
    it 'works' do
      expect{
        get :new
      }.to raise_error
    end
  end

  describe '#create' do
    it 'works' do
      post :create, site: FactoryGirl.build(:site, user: nil).attributes, format: :js

      new_site = assigns(:site)

      expect(new_site).to be_a Site
      expect(new_site.user).to eq login_user
    end

    it 'increases the number of sites' do
      expect{
        post :create, site: FactoryGirl.build(:site, user: nil).attributes, format: :js
      }.to change(Site, :count).by(1)
    end
  end

  describe '#edit' do
    it 'works' do
      xhr :get, :edit, id: site.id, format: :js

      expect(assigns(:site)).to eq(site)

      expect(response).to render_template(:edit)
    end
  end

  describe '#update' do
    it 'works' do
      new_site        = FactoryGirl.build(:site, protocol: 'https')
      site_attributes = new_site.attributes

      xhr :put, :update, id: site.id, site: site_attributes, format: :js

      assigned_site = assigns(:site)

      expect(assigned_site).to be_a Site
      expect(assigned_site.attributes).not_to eq site.attributes

      expect(assigned_site.name).to        eq new_site.name
      expect(assigned_site.hostname).to    eq new_site.hostname
      expect(assigned_site.description).to eq new_site.description
      expect(assigned_site.protocol).to    eq new_site.protocol

      expect(assigned_site.user_id).not_to eq new_site.user_id

      expect(response).to render_template(:update)
    end
  end

  describe '#destroy' do
    it 'works' do
      xhr :delete, :destroy, id: site.id, format: :js

      expect(assigns(:site)).not_to be_persisted

      expect(response).to render_template(:destroy)
    end

    it 'decreases the number of sites' do
      expect{
        xhr :post, :destroy, id: site.id, format: :js
      }.to change(Site, :count).by(-1)
    end
  end

  describe '#general_broadcast' do
    let!(:tip) { FactoryGirl.build :tip }

    it 'works' do
      xhr :post, :general_broadcast, tip: tip.attributes, format: :js

      expect(assigns(:sites).to_a).to eq [site]
      expect(assigns(:saved)).to      eq true

      expect(response).to render_template(:general_broadcast)
    end

    it 'fails' do
      xhr :post, :general_broadcast, tip: tip.attributes.merge(content: ''), format: :js

      expect(assigns(:sites).to_a).to eq [site]
      expect(assigns(:saved)).to      eq false

      expect(response).to render_template(:general_broadcast)
    end
  end

end
