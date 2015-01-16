# -*- encoding: utf-8 -*-

require 'rails_helper'

describe TitleHelper do

  # TODO: auto-generated
  describe '#title' do
    it 'works' do
      expect(helper.title('foo', 'bar')).to eq('foo - bar')
    end

    it 'allows separators' do
      expect(helper.title('foo', 'bar', separator: '#')).to eq('foo#bar')
    end

    it 'allows site' do
      expect(helper.title('foo', 'bar', site: 'baz')).to eq('foo - bar - baz')
    end

    it 'allows headline' do
      expect(helper.title('foo', 'bar', headline: 'baz')).to eq('foo - bar - baz')
    end

    it 'allows headline and site' do
      expect(helper.title('foo', 'bar', headline: 'baz', site: 'barbaz')).to eq('foo - bar - barbaz - baz')
    end

    it 'allows everything' do
      expect(helper.title('foo', 'bar', separator: '#', headline: 'baz', site: 'barbaz')).to eq('foo#bar#barbaz#baz')
    end

    it 'remembers the old titles' do
      helper.title('foo', 'bar')

      expect(helper.title('foo', 'bar')).to eq('foo - bar - foo - bar')
    end
  end

  describe '#headline' do
    it 'works' do
      assign(:_title, %w(foo bar))
      expect(helper.headline).to eq('foo')
    end
  end

end
