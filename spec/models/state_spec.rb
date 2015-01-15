# -*- encoding: utf-8 -*-

require 'spec_helper'

describe State do

  # TODO: auto-generated
  describe '#ephemeral_user' do
    it 'works' do
      result = State.ephemeral_user
      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#dismiss!' do
    it 'works' do
      message = double('message')
      remote_user = double('remote_user')
      up_to = double('up_to')
      result = State.dismiss!(message, remote_user, up_to)
      expect(result).not_to be_nil
    end
  end

end
