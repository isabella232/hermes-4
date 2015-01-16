require 'rails_helper'

describe TutorialsController, type: :controller do
  login

  describe 'routing' do
    it { expect(   get: '/sites/1/tutorials'       ).to route_to(controller: 'tutorials', action: 'index',   site_id: '1')          }
    it { expect(   get: '/sites/1/tutorials/new'   ).to route_to(controller: 'tutorials', action: 'new',     site_id: '1')          }
    it { expect(  post: '/sites/1/tutorials'       ).to route_to(controller: 'tutorials', action: 'create',  site_id: '1')          }
    it { expect(   get: '/sites/1/tutorials/2'     ).to route_to(controller: 'tutorials', action: 'show',    site_id: '1', id: '2') }
    it { expect(   get: '/sites/1/tutorials/2/edit').to route_to(controller: 'tutorials', action: 'edit',    site_id: '1', id: '2') }
    it { expect(   put: '/sites/1/tutorials/2'     ).to route_to(controller: 'tutorials', action: 'update',  site_id: '1', id: '2') }
    it { expect(delete: '/sites/1/tutorials/2'     ).to route_to(controller: 'tutorials', action: 'destroy', site_id: '1', id: '2') }
  end

  describe 'helpers' do
    it { expect(site_tutorials_path(1)).to eq('/sites/1/tutorials') }
  end
end
