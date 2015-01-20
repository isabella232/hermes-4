# -*- encoding: utf-8 -*-

require 'rails_helper'

describe TutorialTipsController do
  login

  let!(:site)     { FactoryGirl.create :site }
  let!(:tutorial) { FactoryGirl.create :tutorial, site: site }
  let!(:tip)      { FactoryGirl.create :tip, tippable: tutorial }

  describe '#index' do
    it 'works' do
      get :index, tutorial_id: tutorial.id

      expect(assigns(:tutorial)).to  eq tutorial
      expect(assigns(:tips).to_a).to eq [tip]

      expect(response).to have_http_status(:ok)
    end

    it 'redirects' do
      new_tutorial = FactoryGirl.create :tutorial, site: site

      get :index, tutorial_id: new_tutorial.id

      expect(assigns(:tutorial)).to  eq new_tutorial
      expect(assigns(:tips).to_a).to be_blank

      expect(response).to redirect_to(new_tutorial_tip_path(new_tutorial))
    end
  end

  describe '#show' do
    it 'fails' do
      expect {
        get :show, tutorial_id: tutorial.id, id: site_tip.id
      }.to raise_error
    end
  end

  describe '#new' do
    it 'works' do
      get :new, tutorial_id: tutorial.id

      expect(assigns(:tutorial)).to eq tutorial
      expect(assigns(:tip)).to      be_a_new Tip

      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    it 'works' do
      post :create, tutorial_id: tutorial.id, tip: FactoryGirl.build(:tip).attributes

      new_tip = assigns(:tip)

      expect(assigns(:tutorial)).to eq tutorial
      expect(new_tip).to            be_a Tip
      expect(new_tip.tippable).to   eq tutorial

      expect(response).to redirect_to(tutorial_tips_path(tutorial))
    end

    it 'saves the tip' do
      expect{
        post :create, tutorial_id: tutorial.id, tip: FactoryGirl.build(:tip).attributes
      }.to change(Tip, :count).by(1)
    end

    it 'adds the tip to the tutorial\'s collection' do
      expect{
        post :create, tutorial_id: tutorial.id, tip: FactoryGirl.build(:tip).attributes
      }.to change(tutorial.tips, :count).by(1)
    end

    it 'fails' do
      post :create, tutorial_id: tutorial.id, tip: FactoryGirl.build(:tip, content: '').attributes

      expect(flash.now[:error]).to be_present
      expect(response).to render_template(:new)
    end
  end

  describe '#edit' do
    it 'works' do
      get :edit, tutorial_id: tutorial.id, id: tip.id

      expect(assigns(:tutorial)).to eq tutorial
      expect(assigns(:tip)).to      eq tip

      expect(response).to have_http_status(:ok)
    end
  end

  describe '#update' do
    it 'works' do
      new_tip        = FactoryGirl.build(:tip)
      tip_attributes = new_tip.attributes

      put :update, tutorial_id: tutorial.id, id: tip.id, tip: tip_attributes

      expect(assigns(:tutorial)).to eq tutorial
      expect(assigns(:tip)).to      eq tip

      expect(response).to redirect_to(tutorial_tips_path(tutorial))
    end

    it 'fails' do
      new_tip        = FactoryGirl.build(:tip, content: '')
      tip_attributes = new_tip.attributes

      put :update, tutorial_id: tutorial.id, id: tip.id, tip: tip_attributes

      expect(flash.now[:error]).to be_present
      expect(response).to render_template(:edit)
    end
  end

  describe '#destroy' do
    it 'works' do
      xhr :delete, :destroy, tutorial_id: tutorial.id, id: tip.id

      expect(assigns(:tutorial)).to eq tutorial
      expect(assigns(:tip)).not_to  be_persisted

      expect(response).to render_template(:destroy)
    end

    it 'decreases the number of sites' do
      expect{
        xhr :delete, :destroy, tutorial_id: tutorial.id, id: tip.id
      }.to change(Tip, :count).by(-1)
    end
  end

end
