module Models
  module PathValidations
    def validate_path
      describe '#validate_path' do
        it 'works' do
          site      = FactoryGirl.create :site, hostname: 'foo.bar/baz'
          new_site  = FactoryGirl.create :site, hostname: 'foo.bar'

          new_model = if subject.respond_to? :site
            FactoryGirl.create described_class.name.underscore, site: site, path: ''
            FactoryGirl.build described_class.name.underscore, site: new_site,  path: '/baz'


          else
            FactoryGirl.create described_class.name.underscore, tippable: site, path: ''
            FactoryGirl.build described_class.name.underscore, tippable: new_site,  path: '/baz'
          end

          expect(new_model).not_to                 be_valid
          expect(new_model.errors_on :path).not_to be_blank
        end
      end
    end

    def before_save_check_path_re
      context 'before_save' do
        describe '#check_path_re' do
          it 'works' do
            subject.path = '/foo'

            expect{
              subject.save
            }.to change(subject, :path_re).to('^/foo$')
          end
        end
      end
    end
  end
end
