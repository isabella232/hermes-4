module PolitenessModel
  def has_many_states
    it { should have_many(:states).dependent(:destroy) }
  end

  def respecting
    describe '#respecting' do
      it 'implements the correct query' do
        expect(State).to receive(:for_type).with(described_class) {State.all}
        expect(State).to receive(:unwanted_by).with('foo') {State.all}

        scope = described_class.respecting('foo')

        expect(scope.where_values.first).to match /id not in \(.*\)/i
      end

      it 'works' do
        site  = FactoryGirl.create :site
        model = FactoryGirl.create described_class.name.underscore.to_sym, :noselector, :site, site: site
        state = FactoryGirl.create :state, message: model, remote_user: 'foo'

        expect(described_class.respecting('foo')).to eq [model]
      end
    end
  end

  def not_respecting
    describe '#not_respecting' do
      it 'implements the correct query' do
        expect(State).to receive(:for_type).with(described_class) {State.all}
        expect(State).to receive(:unwanted_by).with('foo') {State.all}

        scope = described_class.not_respecting('foo')

        expect(scope.where_values.first).to match /id in \(.*\)/i
      end

      it 'works' do
        site  = FactoryGirl.create :site
        model = FactoryGirl.create described_class.name.underscore.to_sym, :noselector, :site, site: site
        state = FactoryGirl.create :state, message: model, show_at: 10.minutes.from_now, remote_user: 'foo'

        expect(described_class.not_respecting('foo')).to eq [model]
      end
    end
  end

  def dismiss!
    describe '#dismiss!' do
      it 'works' do
        model = FactoryGirl.build described_class.name.underscore

        expect(model.states).to receive(:dismiss!).with(model, 'foo', 'bar')

        model.dismiss!('foo', 'bar')
      end
    end
  end
end
