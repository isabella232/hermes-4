# -*- encoding: utf-8 -*-

require 'spec_helper'

describe ApplicationHelper do

  # TODO: auto-generated
  describe '#logo' do
    it 'works' do
      application_helper = ApplicationHelper.new
      result = application_helper.logo
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#gravatar' do
    it 'works' do
      application_helper = ApplicationHelper.new
      email = double('email')
      size = double('size')
      result = application_helper.gravatar(email, size)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#logo_big' do
    it 'works' do
      application_helper = ApplicationHelper.new
      result = application_helper.logo_big
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#hermes_embed_url' do
    it 'works' do
      application_helper = ApplicationHelper.new
      result = application_helper.hermes_embed_url
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#any_sites?' do
    it 'works' do
      application_helper = ApplicationHelper.new
      result = application_helper.any_sites?
      expect(result).not_to be_nil
    end
  end

end
