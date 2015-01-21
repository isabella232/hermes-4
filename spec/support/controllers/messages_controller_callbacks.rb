module Controllers
  module MessagesControllerCallbacks
    def requires_a_callback_param &block
      it 'requires a callback param' do
        request.env["HTTP_REFERER"] = 'http://example.com'

        opts = { site_ref: site.hostname }

        instance_exec(opts, &block)

        expect(response).to have_http_status(:bad_request)

        instance_exec(opts.merge(callback: 'http://foo.bar'), &block)

        expect(response).not_to have_http_status(:bad_request)
      end
    end

    def requires_a_message &block
      let!(:message) { FactoryGirl.create :tutorial }

      it 'works' do
        instance_exec(callback: 'http://foo.bar', site_ref: site.hostname, type: 'tutorial', id: message.id, &block)

        expect(assigns(:message)).to eq message
      end

      it 'requires a type and an id' do
        instance_exec(callback: 'http://foo.bar', type: '', id: '', &block)

        expect(response).to have_http_status(:bad_request)
      end
    end

    def requires_a_site &block
      let!(:opts) { {callback: 'http://foo.bar'} }

      it 'works' do
        site = FactoryGirl.create :site

        request.env["HTTP_REFERER"] = 'http://example.com'

        instance_exec(opts.merge(site_ref: site.hostname), &block)

        expect(assigns(:site)).not_to be_blank
      end

      it "fails without a referer" do
        request.env["HTTP_REFERER"] = nil

        instance_exec(opts, &block)

        expect(response).to have_http_status(:bad_request)
      end

      it 'fails with wrong schema' do
        opts.merge!(site_ref: site.hostname)

        request.env["HTTP_REFERER"] = 'ftp://example.com'

        instance_exec(opts, &block)

        expect(response).to have_http_status(:bad_request)

        %w(http https).each do |protocol|
          request.env["HTTP_REFERER"] = [protocol, '://example.com'].join

          instance_exec(opts, &block)

          expect(response).not_to have_http_status(:bad_request)
        end
      end

      it 'fails if the url is not valid' do
        request.env["HTTP_REFERER"] = 'http://$fuu'

        instance_exec(opts, &block)

        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
