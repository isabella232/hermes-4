require 'rails_helper'

describe TipsController, type: :controller do
  login

  describe 'routing' do
    it { expect(   get: '/sites/1/tips'       ).to route_to(controller: 'tips', action: 'index',   site_id: '1')          }
    it { expect(   get: '/sites/1/tips/new'   ).to route_to(controller: 'tips', action: 'new',     site_id: '1')          }
    it { expect(  post: '/sites/1/tips'       ).to route_to(controller: 'tips', action: 'create',  site_id: '1')          }
    it { expect(   get: '/sites/1/tips/2'     ).to route_to(controller: 'tips', action: 'show',    site_id: '1', id: '2') }
    it { expect(   get: '/sites/1/tips/2/edit').to route_to(controller: 'tips', action: 'edit',    site_id: '1', id: '2') }
    it { expect(   put: '/sites/1/tips/2'     ).to route_to(controller: 'tips', action: 'update',  site_id: '1', id: '2') }
    it { expect(delete: '/sites/1/tips/2'     ).to route_to(controller: 'tips', action: 'destroy', site_id: '1', id: '2') }

    it { expect(   get: '/sites/1/tutorials/2/tips'       ).to route_to(controller: 'tips', action: 'index',   site_id: '1', tutorial_id: '2')         }
    it { expect(   get: '/sites/1/tutorials/2/tips/new'   ).to route_to(controller: 'tips', action: 'new',     site_id: '1', tutorial_id: '2')         }
    it { expect(  post: '/sites/1/tutorials/2/tips'       ).to route_to(controller: 'tips', action: 'create',  site_id: '1', tutorial_id: '2')         }
    it { expect(   get: '/sites/1/tutorials/2/tips/3'     ).to route_to(controller: 'tips', action: 'show',    site_id: '1', tutorial_id: '2', id: '3') }
    it { expect(   get: '/sites/1/tutorials/2/tips/3/edit').to route_to(controller: 'tips', action: 'edit',    site_id: '1', tutorial_id: '2', id: '3') }
    it { expect(   put: '/sites/1/tutorials/2/tips/3'     ).to route_to(controller: 'tips', action: 'update',  site_id: '1', tutorial_id: '2', id: '3') }
    it { expect(delete: '/sites/1/tutorials/2/tips/3'     ).to route_to(controller: 'tips', action: 'destroy', site_id: '1', tutorial_id: '2', id: '3') }

    it { expect(put: '/tips/1/position').to route_to(controller: 'tips', action: 'position', id: '1') }
  end

  describe 'helpers' do
    it { expect(site_tips_path(1)).to eq('/sites/1/tips')       }
    it { expect(tip_position_path(1)).to eq('/tips/1/position') }
  end
end
