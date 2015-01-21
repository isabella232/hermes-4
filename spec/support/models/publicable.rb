module Models
  module Publicable
    def published
      describe '#published' do
        it 'works' do
          scope = described_class.published

          expect(scope.where_values.first).to match(/'[\d :\.-]+' between published_at and unpublished_at/i)
        end
      end
    end

    def validate_publishing_timestamps_sequence
      describe 'validate publishing_timestamps_sequence' do
        it 'works' do
          model = FactoryGirl.build described_class.name.underscore, published_at: 1.day.from_now, unpublished_at: 1.day.ago

          expect(model).not_to                          be_valid
          expect(model.errors_on(:published_at)).not_to be_blank
        end

        it 'works' do
          model = FactoryGirl.build described_class.name.underscore, published_at: nil, unpublished_at: nil

          expect(model.errors_on(:published_at)).to be_blank
          expect(model.published_at).to             eq Time.at(0)
          expect(model.unpublished_at).to           eq Time.at(0xffffffff)
        end
      end
    end

    def published?
      describe '#published?' do
        it 'works' do
          model = FactoryGirl.build described_class.name.underscore, published_at: 1.day.ago, unpublished_at: 1.day.from_now

          expect(model).to be_published

          model.published_at = 1.hour.from_now

          expect(model).not_to be_published

          model.published_at   = 2.hour.ago
          model.unpublished_at = 1.hours.ago

          expect(model).not_to be_published
        end
      end
    end
  end
end
