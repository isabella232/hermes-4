module PathValidationsModel
  def validate_path
    describe '#validate_path' do
      it 'works' do
        site     = FactoryGirl.create :site, hostname: 'foo.bar/baz'
        tip      = FactoryGirl.create :tip, tippable: site, path: ''
        new_site = FactoryGirl.create :site, hostname: 'foo.bar'
        new_tip  = FactoryGirl.build :tip, tippable: new_site,  path: '/baz'

        expect(new_tip).not_to                 be_valid
        expect(new_tip.errors_on :path).not_to be_blank
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
