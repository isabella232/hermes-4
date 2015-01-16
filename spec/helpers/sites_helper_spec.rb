# -*- encoding: utf-8 -*-

require 'rails_helper'

describe SitesHelper do

  # TODO: auto-generated
  describe '#protocol_chooser' do
    it 'works' do
      sites_helper = SitesHelper.new
      f = double('f')
      result = sites_helper.protocol_chooser(f)
      expect(result).not_to be_nil
    end
  end

end
