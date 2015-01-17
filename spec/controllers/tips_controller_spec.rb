# -*- encoding: utf-8 -*-

require 'rails_helper'

describe TipsController do
  login

  let!(:site) { FactoryGirl.create :site }
  let!(:tutorial) { FactoryGirl.create :tutorial, site: site }
  let!(:tutorial_tip) { FactoryGirl.create :tip, tippable: tutorial, tippable_type: 'Tutorial' }
  let!(:site_tip) { FactoryGirl.create :tip, tippable: site, tippable_type: 'Site' }

  describe '#index' do
    context 'with tutorial' do
      it 'works' do
        get :index, site_id: site.id, tutorial_id: tutorial.id

        expect(assigns(:site)).to      eq site
        expect(assigns(:tutorial)).to  eq tutorial
        expect(assigns(:tips).to_a).to eq [tutorial_tip]

        expect(response).to have_http_status(:ok)
      end

      it 'redirects' do
        new_tutorial = FactoryGirl.create :tutorial, site: site

        get :index, site_id: site.id, tutorial_id: new_tutorial.id

        expect(assigns(:site)).to      eq site
        expect(assigns(:tutorial)).to  eq new_tutorial
        expect(assigns(:tips).to_a).to be_blank

        expect(response).to redirect_to(new_site_tutorial_tip_path(site, new_tutorial))
      end
    end

    context 'without tutorial' do
      it 'works' do
        get :index, site_id: site.id

        expect(assigns(:site)).to      eq site
        expect(assigns(:tutorial)).to  be nil
        expect(assigns(:tips).to_a).to eq [site_tip]

        expect(response).to have_http_status(:ok)
      end

      it 'redirects' do
        new_site = FactoryGirl.create :site

        get :index, site_id: new_site.id

        expect(assigns(:site)).to      eq new_site
        expect(assigns(:tutorial)).to  be nil
        expect(assigns(:tips).to_a).to be_blank

        expect(response).to redirect_to(new_site_tip_path(new_site))
      end
    end
  end

  describe '#show' do
    context 'with tutorial' do
      it 'fails' do
        expect {
          get :show, site_id: site.id, tutorial_id: tutorial.id, id: site_tip.id
        }.to raise_error
      end
    end

    context 'without tutorial' do
      it 'fails' do
        expect {
          get :show, site_id: site.id, id: site_tip.id
        }.to raise_error
      end
    end
  end

  describe '#new' do
    context 'with tutorial' do
      it 'works' do
        get :new, site_id: site.id, tutorial_id: tutorial.id

        expect(assigns(:site)).to     eq site
        expect(assigns(:tutorial)).to eq tutorial
        expect(assigns(:tip)).to      be_a_new Tip

        expect(response).to have_http_status(:ok)
      end
    end

    context 'without tutorial' do
      it 'works' do
        get :new, site_id: site.id

        expect(assigns(:site)).to     eq site
        expect(assigns(:tip)).to      be_a_new Tip
        expect(assigns(:tutorial)).to be_blank

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#create' do
    context 'with tutorial' do
      it 'works' do
        post :create, site_id: site.id, tutorial_id: tutorial.id, tip: FactoryGirl.build(:tip).attributes

        new_tip = assigns(:tip)

        expect(assigns(:site)).to     eq site
        expect(assigns(:tutorial)).to eq tutorial
        expect(new_tip).to            be_a Tip
        expect(new_tip.tippable).to   eq tutorial

        expect(response).to redirect_to(site_tutorial_tips_path(site, tutorial))
      end

      it 'saves the tip' do
        expect{
          post :create, site_id: site.id, tutorial_id: tutorial.id, tip: FactoryGirl.build(:tip).attributes
        }.to change(Tip, :count).by(1)
      end

      it 'adds the tip to the tutorial\'s collection' do
        expect{
          post :create, site_id: site.id, tutorial_id: tutorial.id, tip: FactoryGirl.build(:tip).attributes
        }.to change(tutorial.tips, :count).by(1)
      end

      it 'fails' do
        post :create, site_id: site.id, tutorial_id: tutorial.id, tip: FactoryGirl.build(:tip, content: '').attributes

        expect(flash.now[:error]).to be_present
        expect(response).to render_template(:new)
      end

    end

    context 'without tutorial' do
      it 'works' do
        post :create, site_id: site.id, tip: FactoryGirl.build(:tip).attributes

        new_tip = assigns(:tip)

        expect(assigns(:site)).to     eq site
        expect(assigns(:tutorial)).to be nil
        expect(new_tip).to            be_a Tip
        expect(new_tip.tippable).to   eq site

        expect(response).to redirect_to(site_tips_path(site))
      end

      it 'saves the tip' do
        expect{
          post :create, site_id: site.id, tip: FactoryGirl.build(:tip).attributes
        }.to change(Tip, :count).by(1)
      end

      it 'fails' do
        post :create, site_id: site.id, tip: FactoryGirl.build(:tip, content: '').attributes

        expect(flash.now[:error]).to be_present
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#edit' do
    context 'with tutorial' do
      it 'works' do
        get :edit, site_id: site.id, tutorial_id: tutorial.id, id: tutorial_tip.id

        expect(assigns(:site)).to     eq site
        expect(assigns(:tutorial)).to eq tutorial
        expect(assigns(:tip)).to      eq tutorial_tip

        expect(response).to have_http_status(:ok)
      end
    end

    context 'without tutorial' do
      it 'works' do
        get :edit, site_id: site.id, id: site_tip.id

        expect(assigns(:site)).to eq site
        expect(assigns(:tip)).to  eq site_tip

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#update' do
    context 'with tutorial' do
      it 'works' do
        new_tip        = FactoryGirl.build(:tip)
        tip_attributes = new_tip.attributes

        put :update, site_id: site.id, tutorial_id: tutorial.id, id: tutorial_tip.id, tip: tip_attributes

        expect(assigns(:site)).to     eq site
        expect(assigns(:tutorial)).to eq tutorial
        expect(assigns(:tip)).to      eq tutorial_tip

        expect(response).to redirect_to(site_tutorial_tips_path(site, tutorial))
      end

      it 'fails' do
        new_tip        = FactoryGirl.build(:tip, content: '')
        tip_attributes = new_tip.attributes

        put :update, site_id: site.id, tutorial_id: tutorial.id, id: tutorial_tip.id, tip: tip_attributes

        expect(flash.now[:error]).to be_present
        expect(response).to render_template(:edit)
      end
    end

    context 'without tutorial' do
      it 'works' do
        new_tip        = FactoryGirl.build(:tip)
        tip_attributes = new_tip.attributes

        put :update, site_id: site.id, id: site_tip.id, tip: tip_attributes

        expect(assigns(:site)).to     eq site
        expect(assigns(:tutorial)).to be nil
        expect(assigns(:tip)).to      eq site_tip

        expect(response).to redirect_to(site_tips_path(site))
      end

      it 'fails' do
        new_tip        = FactoryGirl.build(:tip, content: '')
        tip_attributes = new_tip.attributes

        put :update, site_id: site.id, id: site_tip.id, tip: tip_attributes

        expect(flash.now[:error]).to be_present
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#destroy' do
    context 'with tutorial' do
      it 'works' do
        xhr :delete, :destroy, site_id: site.id, tutorial_id: tutorial.id, id: tutorial_tip.id

        expect(assigns(:site)).to     eq site
        expect(assigns(:tutorial)).to eq tutorial
        expect(assigns(:tip)).not_to  be_persisted

        expect(response).to render_template(:destroy)
      end

      it 'decreases the number of sites' do
        expect{
          xhr :delete, :destroy, site_id: site.id, tutorial_id: tutorial.id, id: tutorial_tip.id
        }.to change(Tip, :count).by(-1)
      end
    end

    context 'without tutorial' do
      it 'works' do
        xhr :delete, :destroy, site_id: site.id, id: site_tip.id

        expect(assigns(:site)).to     eq site
        expect(assigns(:tutorial)).to be nil
        expect(assigns(:tip)).not_to  be_persisted

        expect(response).to render_template(:destroy)
      end

      it 'decreases the number of sites' do
        expect{
          xhr :delete, :destroy, site_id: site.id, id: site_tip.id
        }.to change(Tip, :count).by(-1)
      end
    end
  end

end
