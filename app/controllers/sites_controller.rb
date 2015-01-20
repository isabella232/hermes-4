# This controllers is the backend core, from which users manage the sites
# they want to get the help elements in.
#
class SitesController < ApplicationController
  include Authenticated

  load_and_authorize_resource except: %w( new )

  def index
  end

  def show
  end

  def create
    @site.attributes = site_params
    @site.user_id = current_user.id
    @site.save

    respond_to do |format|
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    @site.update_attributes(site_params)

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @site.destroy
    respond_to do |format|
      format.js
    end
  end

  def general_broadcast
    @sites = Site.accessible_by(current_ability)
    @saved = true
    @sites.each do |site|
      tip = site.tips.new(tip_params)
      @saved = false unless tip.save
    end
    respond_to do |format|
      format.js
    end
  end

  protected
    def site_params
      params.require(:site).permit(:name, :hostname, :description, :protocol)
    end

    def tip_params
      params.require(:tip).permit(
        :title, :content, :published_at, :path,
        :unpublished_at, :selector, :position, :redisplay
      )
    end
end
