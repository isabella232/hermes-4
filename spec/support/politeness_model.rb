module PolitenessModel
  def has_many_states
    it { should have_many(:states).dependent(:destroy) }
  end

  def respecting
    describe '#respecting' do
      it 'works' do
        expect(State).to receive(:for_type).with(described_class) {State.all}
        expect(State).to receive(:unwanted_by).with('foo') {State.all}

        scope = described_class.respecting('foo')

        expect(scope.where_values.first).to match /id not in \(.*\)/i
      end
    end
  end

  def not_respecting
    describe '#not_respecting' do
      it 'works' do
        expect(State).to receive(:for_type).with(described_class) {State.all}
        expect(State).to receive(:unwanted_by).with('foo') {State.all}

        scope = described_class.not_respecting('foo')

        expect(scope.where_values.first).to match /id in \(.*\)/i
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
