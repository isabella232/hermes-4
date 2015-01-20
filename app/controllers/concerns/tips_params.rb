module TipsParams
  extend ActiveSupport::Concern

  protected
    def tip_params
      params.require(:tip).permit(
        :title, :content, :published_at, :path,
        :unpublished_at, :selector, :position, :redisplay,
        :tutorial_id, :site_host_ref, :path_re
      ).tap do |params|
        params[:redisplay] = nil if params[:redisplay] === '0'
        params[:site_host_ref] = nil unless @tutorial
      end
    end
end
