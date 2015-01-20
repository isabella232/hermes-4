# -*- encoding: utf-8 -*-

require 'rails_helper'

describe TipsHelper do
  let!(:site) { FactoryGirl.create :site }
  let!(:tutorial) { FactoryGirl.create :tutorial, site: site }
  let!(:tip) { FactoryGirl.create :tip, tippable: tutorial, tippable_type: 'Tutorial', path: '/' }

  before do
    assign(:site, site)
  end

  describe '#edit_tip_link' do
    it 'works' do
      expect(helper.edit_tip_link(tip)).to include(edit_site_tip_path(site, tip))

      assign(:tutorial, tutorial)
      expect(helper.edit_tip_link(tip)).to include(edit_tutorial_tip_path(tutorial, tip))
    end
  end

  describe '#destroy_tip_link' do
    it 'works' do
      expect(helper.destroy_tip_link(tip)).to include(site_tip_path(site, tip))

      assign(:tutorial, tutorial)
      expect(helper.destroy_tip_link(tip)).to include(tutorial_tip_path(tutorial, tip))
    end
  end

  describe '#index_title' do
    it 'works' do
      expect(helper.index_title).to include('All tips:')

      assign(:tutorial, tutorial)
      expect(helper.index_title).to include('All tips for')
      expect(helper.index_title).to include(tutorial.title)
    end
  end

  describe '#new_tip_link' do
    it 'works' do
      expect(helper.new_tip_link).to include(new_site_tip_path(site))

      assign(:tutorial, tutorial)
      expect(helper.new_tip_link).to include(new_tutorial_tip_path(tutorial))
    end
  end

  describe '#preview_tip_link' do
    it 'works' do
      expect(helper.preview_tip_link(tip)).to include(site.url + '/')

      tip.site_host_ref = 'foo'
      expect(helper.preview_tip_link(tip)).to include('foo/')

      expect(helper.preview_tip_link(tip)).to include('class="btn btn-default btn-xs ext"')
      expect(helper.preview_tip_link(tip)).to include('class="fa fa-eye"')

      expect(helper.preview_tip_link(tip)).to include("data-messagepath=\"#{message_path('tip', tip.id)}\"")

      assign(:tutorial, tutorial)
      expect(helper.preview_tip_link(tip)).to include("data-messagepath=\"#{message_tutorial_path(tutorial.id, 'tip', tip.id)}\"")
    end
  end

  describe '#site_path_select' do
    it 'works' do
      obj      = double
      new_site = FactoryGirl.create(:site)

      tip.site_host_ref = 'foo'

      expect(obj).to receive(:object).and_return(tip)
      expect(obj).to receive(:select).with(:site_host_ref, anything, {include_blank: 'select site host ref'})
      expect(helper).to receive(:current_user).and_return(new_site.user)
      expect(helper).to receive(:options_for_select).with([[new_site.url, new_site.url]], 'foo')

      helper.site_path_select(obj)
    end
  end

end
