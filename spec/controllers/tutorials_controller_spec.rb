# -*- encoding: utf-8 -*-

require 'rails_helper'

describe TutorialsController do
  login

  let!(:site)     { FactoryGirl.create :site }
  let!(:tutorial) { FactoryGirl.create :tutorial, site: site }
  let!(:tip)      { FactoryGirl.create :tip, tippable: tutorial, tippable_type: 'Tutorial' }

  describe '#index' do
    it 'works' do
      get :index, site_id: site.id
      expect(assigns(:site)).to           eq site
      expect(assigns(:tutorials).to_a).to eq [tutorial]

      expect(response).to have_http_status(:ok)
    end

    it 'redirects' do
      new_site = FactoryGirl.create :site

      get :index, site_id: new_site.id

      expect(assigns(:site)).to           eq new_site
      expect(assigns(:tutorials).to_a).to have(0).items

      expect(response).to redirect_to(new_site_tutorial_path(new_site))
    end
  end

  describe '#show' do
    it 'works' do
      get :show, site_id: site.id, id: tutorial.id

      expect(assigns(:site)).to     eq site
      expect(assigns(:tutorial)).to eq tutorial
      expect(assigns(:tips)).to     eq [tip]

      expect(response).to have_http_status(:ok)
    end
  end

  describe '#new' do
    it 'works' do
      get :new, site_id: site.id

      expect(assigns(:site)).to          eq site
      expect(assigns(:tutorial)).to      be_a_new Tutorial
      expect(assigns(:tutorial).site).to eq site

      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    it 'works' do
      post :create, site_id: site.id, tutorial: FactoryGirl.build(:tutorial).attributes

      new_tutorial = assigns(:tutorial)

      expect(assigns(:site)).to    eq site
      expect(new_tutorial).to      be_a Tutorial
      expect(new_tutorial.site).to eq site

      expect(response).to redirect_to(site_tutorial_path(site, new_tutorial))
    end

    it 'fails' do
      post :create, site_id: site.id, tutorial: FactoryGirl.build(:tutorial, title: '').attributes

      new_tutorial = assigns(:tutorial)

      expect(assigns(:site)).to    eq site
      expect(new_tutorial).to      be_a Tutorial
      expect(new_tutorial.site).to eq site

      expect(flash.now[:error]).to be_present
      expect(response).to render_template(:new)
    end

    it 'increases the number of sites' do
      expect{
        post :create, site_id: site.id, tutorial: FactoryGirl.build(:tutorial).attributes
      }.to change(Tutorial, :count).by(1)
    end
  end

  describe '#edit' do
    it 'works' do
      get :edit, site_id: site.id, id: tutorial.id

      expect(assigns(:site)).to     eq site
      expect(assigns(:tutorial)).to eq tutorial

      expect(response).to have_http_status(:ok)
    end
  end

  describe '#update' do
    it 'works' do
      new_tutorial        = FactoryGirl.build(:tutorial)
      tutorial_attributes = new_tutorial.attributes

      put :update, site_id: site.id, id: tutorial.id, tutorial: tutorial_attributes

      expect(assigns(:site)).to     eq site
      expect(assigns(:tutorial)).to eq tutorial

      expect(response).to redirect_to(site_tutorial_path(site, tutorial))
    end

    it 'fails' do
      new_tutorial        = FactoryGirl.build(:tutorial, title: '')
      tutorial_attributes = new_tutorial.attributes

      put :update, site_id: site.id, id: tutorial.id, tutorial: tutorial_attributes

      expect(assigns(:site)).to     eq site
      expect(assigns(:tutorial)).to eq tutorial

      expect(response).to render_template(:edit)
    end
  end

  describe '#destroy' do
    it 'works' do
      xhr :delete, :destroy, site_id: site.id, id: tutorial.id

      expect(assigns(:site)).to         eq site
      expect(assigns(:tutorial)).not_to be_persisted

      expect(response).to render_template(:destroy)
    end

    it 'decreases the number of sites' do
      expect{
        xhr :delete, :destroy, site_id: site.id, id: tutorial.id
      }.to change(Tutorial, :count).by(-1)
    end
  end

end
