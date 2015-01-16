# -*- encoding: utf-8 -*-

require 'rails_helper'

describe User do

  it { should have_many(:sites).inverse_of(:user).dependent(:destroy) }

end
