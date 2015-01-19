# -*- encoding: utf-8 -*-

require 'rails_helper'

describe Tip do
  extend PublicableModel
  extend PolitenessModel
  extend PathScopingModel
  extend PathValidationsModel

  subject { FactoryGirl.create(:tip_with_tutorial) }

  has_many_states

  it { should belong_to(:tippable).inverse_of(:tips) }

  it { should validate_presence_of(:tippable_id) }
  it { should validate_presence_of(:tippable_type) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }

  validate_publishing_timestamps_sequence
  validate_path

  context 'callbacks' do
    before_save_check_path_re

    context 'before_save' do
      let!(:state) { FactoryGirl.create :state, message: subject }

      it 'works' do
        subject.redisplay = true

        expect{subject.save}.to change(State, :count)
      end

      it 'needs redisplay' do
        expect{subject.save}.not_to change(State, :count)
      end
    end

    context 'before_validation' do
      it 'works' do
        new_tip = FactoryGirl.build :tip_with_tutorial

        expect(new_tip).to receive(:position=).with(:last)

        new_tip.save
      end
    end
  end

  context 'scopes' do
    published
    respecting
    not_respecting
    within

    describe '#sort_by_row_order' do
      it 'works' do
        scope = described_class.sort_by_row_order

        expect(scope.order_values.first.to_sql).to match(/"tips"\."row_order" ASC/i)
      end
    end

    describe '#broadcasts_first' do
      it 'works' do
        scope = described_class.broadcasts_first

        expect(scope.order_values.first).to match(/case selector when '' then 0 else 1 end/i)
      end
    end

    describe '#sorted' do
      it 'works' do
        order = described_class.sorted.order_values

        expect(order).to              have(2).items
        expect(order.first.to_sql).to match(/"tips"\."row_order" ASC/i)
        expect(order.last).to         match(/case selector when '' then 0 else 1 end/i)
      end
    end
  end

  published?
  dismiss!

  describe '#position=' do
    it 'works' do
      expect(subject.row_order_position).not_to eq 10

      subject.position = 10

      expect(subject.row_order_position).to eq 10
    end
  end

end
