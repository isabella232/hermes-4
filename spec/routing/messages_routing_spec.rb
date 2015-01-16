require 'rails_helper'

describe MessagesController, type: :controller do
  describe 'routing' do
    it { expect(get: '/messages/tutorials.js'    ).to route_to(controller: 'messages', action: 'tutorials')                                                      }
    it { expect(get: '/messages/tutorials/1.js'  ).to route_to(controller: 'messages', action: 'tutorial', tutorial_id: '1')                                     }
    it { expect(get: '/message/tutorial/1/type/2').to route_to(controller: 'messages', action: 'show_tutorial_message', tutorial_id: '1', type: 'type', id: '2') }

    it { expect(get: '/messages.js'    ).to route_to(controller: 'messages', action: 'index')                         }
    it { expect(get: '/messages/type/1').to route_to(controller: 'messages', action: 'update', type: 'type', id: '1') }
    it { expect(get: '/message/type/1' ).to route_to(controller: 'messages', action: 'show', type: 'type', id: '1')   }
  end

  describe 'helpers' do
    it { expect(message_tutorial_path(1, 'type', 2)).to eq('/message/tutorial/1/type/2') }
    it { expect(dismiss_message_path('type', 1)    ).to eq('/messages/type/1')           }
    it { expect(message_path('type', 1)            ).to eq('/message/type/1')            }
  end
end
