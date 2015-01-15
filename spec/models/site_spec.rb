# -*- encoding: utf-8 -*-

require 'spec_helper'

describe Site do

  # TODO: auto-generated
  describe '#by_user' do
    it 'works' do
      user = double('user')
      result = Site.by_user(user)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#by_url' do
    it 'works' do
      url = double('url')
      result = Site.by_url(url)
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#url' do
    it 'works' do
      site = Site.new
      result = site.url
      expect(result).not_to be_nil
    end
  end

end
