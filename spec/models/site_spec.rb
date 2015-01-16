# -*- encoding: utf-8 -*-

require 'rails_helper'

describe Site do
  subject { FactoryGirl.create(:site, protocol: 'http') }

  it { should belong_to(:user).inverse_of(:sites) }

  it { should have_many(:tips).inverse_of(:tippable).dependent(:destroy) }
  it { should have_many(:tutorials).inverse_of(:site).dependent(:destroy) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:hostname) }
  it { should validate_presence_of(:protocol) }

  it { should validate_uniqueness_of(:user_id).scoped_to(:hostname) }
  it { should validate_uniqueness_of(:name).scoped_to(:hostname) }
  it { should validate_uniqueness_of(:protocol).scoped_to(:hostname) }
  it { should validate_uniqueness_of(:hostname) }

  it { should allow_value('foo.com').for(:hostname) }
  it { should allow_value('foo-bar.com').for(:hostname) }
  it { should_not allow_value('foo').for(:hostname) }
  it { should_not allow_value('foo$.bar').for(:hostname) }

  it { should validate_inclusion_of(:protocol).in_array(%w(http https)) }

  context 'scopes' do
    describe '#by_user' do
      let!(:user) { FactoryGirl.create(:user) }

      it "returns records belonging to a concrete user" do
        expect(described_class.by_user(user).where_values_hash).to eq('user_id' => user.id)
      end
    end
  end

  describe '.url' do
    it 'works' do
      expect(subject.url).to eq("#{subject.protocol}://#{subject.hostname}")
    end
  end

end
