require 'rails_helper'

describe SitesController, type: :controller do
  login

  describe 'routing' do
    it { expect(   get: '/'            ).to route_to(controller: 'sites', action: 'index')            }

    it { expect(   get: '/sites'       ).to route_to(controller: 'sites', action: 'index')            }
    it { expect(  post: '/sites'       ).to route_to(controller: 'sites', action: 'create')           }
    it { expect(   get: '/sites/1'     ).to route_to(controller: 'sites', action: 'show',    id: '1') }
    it { expect(   get: '/sites/1/edit').to route_to(controller: 'sites', action: 'edit',    id: '1') }
    it { expect(   put: '/sites/1'     ).to route_to(controller: 'sites', action: 'update',  id: '1') }
    it { expect(delete: '/sites/1'     ).to route_to(controller: 'sites', action: 'destroy', id: '1') }

    it { expect(post: '/sites/general_broadcast' ).to route_to(controller: 'sites', action: 'general_broadcast') }
  end

  describe 'helpers' do
    it { expect(sites_path).to eq('/sites')                               }
    it { expect(general_broadcast_path).to eq('/sites/general_broadcast') }
  end
end
