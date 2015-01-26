# -*- encoding: utf-8 -*-

require 'rails_helper'

describe TipsController do
  login

  let!(:site) { FactoryGirl.create :site, user: login_user }
  let!(:tip)  { FactoryGirl.create :tip, tippable: site }

  describe '#position' do
    it 'works' do
      xhr :put, :position, id: tip.id, pos: 1

      expect(assigns(:tip)).to eq tip

      expect(response).to have_http_status(:ok)
    end

    it 'needs pos parameter' do
      xhr :put, :position, id: tip.id

      expect(response).to have_http_status(:bad_request)
    end

    it 'needs a valid pos parameter' do
      xhr :put, :position, id: tip.id, pos: -1

      expect(response).to have_http_status(:bad_request)
    end
  end
end
