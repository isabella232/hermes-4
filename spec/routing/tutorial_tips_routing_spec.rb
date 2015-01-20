require 'rails_helper'

describe TutorialTipsController, type: :controller do
  login

  describe 'routing' do
    it { expect(   get: '/tutorials/1/tips'       ).to route_to(controller: 'tutorial_tips', action: 'index',   tutorial_id: '1')         }
    it { expect(   get: '/tutorials/1/tips/new'   ).to route_to(controller: 'tutorial_tips', action: 'new',     tutorial_id: '1')         }
    it { expect(  post: '/tutorials/1/tips'       ).to route_to(controller: 'tutorial_tips', action: 'create',  tutorial_id: '1')         }
    it { expect(   get: '/tutorials/1/tips/2'     ).to route_to(controller: 'tutorial_tips', action: 'show',    tutorial_id: '1', id: '2') }
    it { expect(   get: '/tutorials/1/tips/2/edit').to route_to(controller: 'tutorial_tips', action: 'edit',    tutorial_id: '1', id: '2') }
    it { expect(   put: '/tutorials/1/tips/2'     ).to route_to(controller: 'tutorial_tips', action: 'update',  tutorial_id: '1', id: '2') }
    it { expect(delete: '/tutorials/1/tips/2'     ).to route_to(controller: 'tutorial_tips', action: 'destroy', tutorial_id: '1', id: '2') }
  end

  describe 'helpers' do
    it { expect(tutorial_tips_path(1)).to eq('/tutorials/1/tips') }
  end
end
