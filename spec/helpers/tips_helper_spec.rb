# -*- encoding: utf-8 -*-

require 'spec_helper'

describe TipsHelper do

  # TODO: auto-generated
  describe '#edit_tip_link' do
    it 'works' do
      tips_helper = TipsHelper.new
      tip = double('tip')
      result = tips_helper.edit_tip_link(tip)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#destroy_tip_link' do
    it 'works' do
      tips_helper = TipsHelper.new
      tip = double('tip')
      result = tips_helper.destroy_tip_link(tip)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#index_title' do
    it 'works' do
      tips_helper = TipsHelper.new
      result = tips_helper.index_title
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#new_tip_link' do
    it 'works' do
      tips_helper = TipsHelper.new
      result = tips_helper.new_tip_link
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#preview_tip_link' do
    it 'works' do
      tips_helper = TipsHelper.new
      tip = double('tip')
      result = tips_helper.preview_tip_link(tip)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#site_path_select' do
    it 'works' do
      tips_helper = TipsHelper.new
      f = double('f')
      result = tips_helper.site_path_select(f)
      expect(result).not_to be_nil
    end
  end

end
