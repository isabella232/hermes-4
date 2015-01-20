require 'rails_helper'

describe SiteTipsController, type: :controller do
  login

  describe 'routing' do
    it { expect(   get: '/sites/1/tips'       ).to route_to(controller: 'site_tips', action: 'index',   site_id: '1')          }
    it { expect(   get: '/sites/1/tips/new'   ).to route_to(controller: 'site_tips', action: 'new',     site_id: '1')          }
    it { expect(  post: '/sites/1/tips'       ).to route_to(controller: 'site_tips', action: 'create',  site_id: '1')          }
    it { expect(   get: '/sites/1/tips/2'     ).to route_to(controller: 'site_tips', action: 'show',    site_id: '1', id: '2') }
    it { expect(   get: '/sites/1/tips/2/edit').to route_to(controller: 'site_tips', action: 'edit',    site_id: '1', id: '2') }
    it { expect(   put: '/sites/1/tips/2'     ).to route_to(controller: 'site_tips', action: 'update',  site_id: '1', id: '2') }
    it { expect(delete: '/sites/1/tips/2'     ).to route_to(controller: 'site_tips', action: 'destroy', site_id: '1', id: '2') }
  end

  describe 'helpers' do
    it { expect(site_tips_path(1)).to eq('/sites/1/tips') }
  end
end
