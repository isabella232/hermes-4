# -*- encoding: utf-8 -*-

require 'spec_helper'

describe State do
  subject { FactoryGirl.create(:state_with_tip) }

  it { should belong_to(:message) }

  it { should validate_presence_of(:message_id) }
  it { should validate_presence_of(:message_type) }
  it { should validate_presence_of(:remote_user) }

  context 'scopes' do
    describe '#for_type' do
      it "returns records with a concrete type" do
        expect(described_class.for_type('foo').where_values_hash).to \
          eq('message_type' => 'foo')
      end
    end

    describe '#unwanted_by' do
      it "returns records with a concrete remote user" do
        expect(Time).to receive(:now).and_return('1234').at_least(1).times

        scope = described_class.unwanted_by('foo')

        expect(scope.where_values).to have(2).items
        expect(scope.where_values.last).to eq("show_at > '1234'")
        expect(scope.where_values.first.to_sql).to \
          eq("\"states\".\"remote_user\" = 'foo'")

        expect(scope.select_values).to eq([:message_id])
      end
    end
  end

  describe '#ephemeral_user' do
    it 'works' do
      expect(SecureRandom).to receive(:hex).with(48).and_return('foo')

      result = described_class.ephemeral_user
      expect(result).to eq('huid_foo')
    end
  end

  describe '#dismiss!' do
    let!(:message) { FactoryGirl.create :tip_with_tutorial }
    let!(:remote_user) { 'foo' }
    let!(:up_to) { 1.day.from_now }
    let!(:attributes) do
      {
        message_id: message.id,
        message_type: 'Tip',
        remote_user: 'foo'
      }
      end

    it 'works' do
      expect(described_class).to \
        receive(:find_or_initialize_by)
          .with(attributes)
          .and_return(described_class.new(attributes))

      result = described_class.dismiss! message, remote_user, up_to

      expect(result).not_to be_nil
    end

    it 'returns false if no changes occurred' do
      state  = described_class.create!(attributes.merge show_at: up_to).tap &:reload
      result = described_class.dismiss! message, remote_user, state.show_at

      expect(result).to be false
    end

    it "automatically sets show_at" do
      expect(described_class.count).to be 0

      described_class.dismiss! message, remote_user

      expect(described_class.count).to be 1

      expect(described_class.first.show_at).to eq(Time.at(0xffffffff))
    end

    it "ignores the last parameter" do
      expect(described_class.count).to be 0

      described_class.dismiss! message, remote_user, 1.day.ago

      expect(described_class.count).to be 1

      expect(described_class.first.show_at).to eq(Time.at(0xffffffff))
    end
  end

end
