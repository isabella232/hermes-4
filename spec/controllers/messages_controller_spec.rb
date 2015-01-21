# -*- encoding: utf-8 -*-

require 'rails_helper'

describe MessagesController do
  extend MessagesControllerCallbacks

  let!(:remote_user) { 'foo' }
  let!(:site)        { FactoryGirl.create :site }
  let!(:tutorial)    { FactoryGirl.create :tutorial, site: site }

  before do
    request.env["HTTP_REFERER"]      = 'http://example.com'
    request.cookies['__hermes_user'] = remote_user
  end

  describe '#index' do
    requires_a_callback_param { |opts={}| get :index, opts }
    requires_a_site           { |opts={}| get :index, opts }

    it 'works' do
      tips = FactoryGirl.create_list :tip, 5, tippable: site

      get :index, callback: 'http://foo.bar', site_ref: site.hostname

      expect(assigns(:site)).to      eq site
      expect(assigns(:messages)).to  eq tips

      expect(response).to render_template('messages/index.json')
    end

    it 'looks for published messages' do
      tips = FactoryGirl.create_list :tip_unpublished, 5, tippable: site

      get :index, callback: 'http://foo.bar', site_ref: site.hostname

      expect(assigns(:messages)).to be_blank
    end
  end

  describe '#tutorial' do
    requires_a_callback_param { |opts={}| get :tutorial, opts.merge(tutorial_id: tutorial.id) }
    requires_a_site           { |opts={}| get :tutorial, opts.merge(tutorial_id: tutorial.id) }

    it 'works' do
      get :tutorial, tutorial_id: tutorial.id, callback: 'http://foo.bar', site_ref: site.hostname

      expect(assigns(:tutorials)).to eq [tutorial]

      expect(response).to render_template('messages/tutorial.json')
    end

    it 'requires site user to be tutoriaal site user' do
      new_tutorial = FactoryGirl.create :tutorial
      new_site     = new_tutorial.site

      get :tutorial, tutorial_id: new_tutorial.id, callback: 'http://foo.bar', site_ref: site.hostname

      expect(response).to have_http_status(:not_found)
    end
  end

  describe '#tutorials' do
    let!(:tutorial)               { FactoryGirl.create :tutorial_noselector, site: site }
    let!(:state)                  { FactoryGirl.create :state, message: tutorial, remote_user: remote_user }
    let!(:viewed_tutorial)        { FactoryGirl.create :tutorial_noselector, site: site }
    let!(:viewed_state)           { FactoryGirl.create :state, message: viewed_tutorial, show_at: 10.minutes.from_now, remote_user: remote_user }
    let!(:tutorial_with_selector) { FactoryGirl.create :tutorial, site: site }
    let!(:state_with_selector)    { FactoryGirl.create :state, message: tutorial_with_selector, remote_user: remote_user }

    requires_a_callback_param { |opts={}| get :tutorials, opts }
    requires_a_site           { |opts={}| get :tutorials, opts }

    it 'works' do
      get :tutorials, callback: 'http://foo.bar', site_ref: site.hostname

      expect(assigns(:tutorials_to_view)).to         eq [tutorial]
      expect(assigns(:tutorials_already_viewed)).to  eq [viewed_tutorial]
      expect(assigns(:tutorials_with_selector)).to   eq [tutorial_with_selector]

      expect(response).to render_template('messages/tutorials.json')
    end
  end

  describe '#show' do
    let!(:tip) { FactoryGirl.create(:tip, tippable: tutorial) }

    context 'without tutorial' do
      requires_a_callback_param { |opts={}| get :show, opts.merge(type: 'Tutorial', id: tutorial.id, format: :js) }
      requires_a_site           { |opts={}| get :show, opts.merge(type: 'Tutorial', id: tutorial.id, format: :js) }
      requires_a_message        { |opts={}| get :show, opts.merge(format: :js) }

      it 'works' do
        get :show, callback: 'http://foo.bar', site_ref: site.hostname, type: 'tutorial', id: tutorial.id, format: :js

        expect(response).to render_template('messages/_message')
      end
    end

    context 'with tutorial' do
      requires_a_callback_param { |opts={}| get :show, opts.merge(tutorial_id: tutorial.id, type: 'Tutorial', id: tutorial.id, format: :js) }
      requires_a_site           { |opts={}| get :show, opts.merge(tutorial_id: tutorial.id, type: 'Tutorial', id: tutorial.id, format: :js) }
      requires_a_message        { |opts={}| get :show, opts.merge(tutorial_id: tutorial.id, format: :js) }

      it 'works' do
        get :show, callback: 'http://foo.bar', site_ref: site.hostname, type: 'tip', id: tip.id, format: :js

        expect(response).to render_template('messages/_message')
      end
    end
  end

  describe '#update' do
    let!(:state) { FactoryGirl.create :state, message: tutorial, remote_user: remote_user }

    requires_a_callback_param { |opts={}| get :update, opts.merge(type: 'Tutorial', id: tutorial.id, format: :js) }
    requires_a_site           { |opts={}| get :update, opts.merge(type: 'Tutorial', id: tutorial.id, format: :js) }
    requires_a_message        { |opts={}| get :update, opts }

    it 'works' do
      get :update, callback: 'http://foo.bar', site_ref: site.hostname, type: 'Tutorial', id: tutorial.id, format: :js

      expect(response).to have_http_status(:created)
    end
  end

end
