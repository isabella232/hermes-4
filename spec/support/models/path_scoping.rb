module Models
  module PathScoping
    def within
      describe '#within' do
        context 'postgres' do
          it 'works' do
            scope = described_class.within('/foo')

            expect(scope.where_values.first).to match /'\/foo' ~\* path_re/i
          end
        end

        context 'mysql or sqlite' do
        end

        context 'other' do
        end
      end
    end
  end
end
