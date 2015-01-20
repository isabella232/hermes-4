require 'rails_helper'

describe MessagesController, type: :controller do
  describe 'routing' do
    it { expect(get: '/messages/tutorials').to   route_to(controller: 'messages', action: 'tutorials')                  }
    it { expect(get: '/messages/tutorials/1').to route_to(controller: 'messages', action: 'tutorial', tutorial_id: '1') }

    it { expect(get: '/messages').to        route_to(controller: 'messages', action: 'index')                         }
    it { expect(get: '/messages/1/type').to route_to(controller: 'messages', action: 'update', type: 'type', id: '1') }
    it { expect(get: '/messages/1').to      route_to(controller: 'messages', action: 'show', id: '1')                 }
  end

  describe 'helpers' do
    it { expect(dismiss_message_path(1, 'type')).to  eq('/messages/1/type')    }
    it { expect(tutorials_messages_path).to          eq('/messages/tutorials') }
    it { expect(message_path(1)).to                  eq('/messages/1')         }
  end
end
