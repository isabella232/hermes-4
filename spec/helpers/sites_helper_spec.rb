# -*- encoding: utf-8 -*-

require 'rails_helper'

describe SitesHelper do

  describe '#protocol_chooser' do
    let!(:site) { FactoryGirl.create :site }

    it 'works' do
      obj = double

      expect(obj).to receive(:object).and_return(site)
      expect(obj).to receive(:select).with(:protocol, anything)
      expect(helper).to receive(:options_for_select).with(['http', 'https'], site.protocol)

      helper.protocol_chooser(obj)
    end
  end

end
