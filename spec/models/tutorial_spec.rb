# -*- encoding: utf-8 -*-

require 'rails_helper'

describe Tutorial do
  extend Models::Publicable
  extend Models::Politeness
  extend Models::PathScoping
  extend Models::PathValidations

  subject { FactoryGirl.create(:tutorial) }

  has_many_states

  it { should belong_to(:site).inverse_of(:tutorials) }

  it { should have_many(:tips).inverse_of(:tippable).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:site_id) }

  validate_publishing_timestamps_sequence
  validate_path

  context 'validations' do
    describe '#normalize_path' do
      it 'works' do
        subject.path = '   /foo/  bar '

        expect{
          subject.save
        }.to change(subject, :path).to('/foo/bar')
      end
    end
  end

  context 'callbacks' do
    before_save_check_path_re
  end

  context 'scopes' do
    published
    respecting
    not_respecting
    within
  end

  published?
  dismiss!

end
