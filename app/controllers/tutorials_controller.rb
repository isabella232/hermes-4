class TutorialsController < ApplicationController
  include Authenticated

  load_and_authorize_resource :site
  load_and_authorize_resource :tutorial, :through => :site

  before_filter :generate_xd_token, only: %w( new edit )

  def index
    @tutorials = @tutorials.order('created_at DESC')

    redirect_to new_site_tutorial_path(@site) if @tutorials.blank?
  end

  def show
    @tips = @tutorial.tips.sort_by_row_order
  end

  def new
  end

  def create
    @tutorial.attributes = tutorial_params
    @tutorial.site = @site

    if @tutorial.save
      redirect_to site_tutorial_path(@site, @tutorial)
    else
      flash.now[:error] = 'There was an error saving your tutorial.'
      render :new
    end
  end

  def edit
  end

  def update
    if @tutorial.update_attributes(tutorial_params)
      # update also tips that don't have path
      @tutorial.tips.update_path(@tutorial.path)

      redirect_to site_tutorial_path(@site, @tutorial), :notice => 'tutorial saved'
    else
      render :edit
    end
  end

  def destroy
    @tutorial.destroy
    respond_to do |format|
      format.js
    end
  end

  protected

    def tutorial_params
      params.
        require(:tutorial).
        permit(:title, :published_at,
               :unpublished_at, :path, :position,
               :selector, :welcome_message,
               :overlay, :progress_bar, :path_re)
    end

    # This is a token to passed between the #tip-connector and the
    # target web site, to enable the authoring component in it and
    # to authorize communication.
    #
    # TODO: actually use a random token and verify it - for now it
    # is only used to pass the opener scheme to postMessage.
    #
    def generate_xd_token
      @connector_token = "authoring-tutorial"
    end

end
