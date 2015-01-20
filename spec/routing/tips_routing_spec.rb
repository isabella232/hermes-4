require 'rails_helper'

describe TipsController, type: :controller do
  login

  describe 'routing' do
    it { expect(put: '/tips/1/position').to route_to(controller: 'tips', action: 'position', id: '1') }
  end

  describe 'helpers' do
    it { expect(tip_position_path(1)).to eq('/tips/1/position') }
  end
end
