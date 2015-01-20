class TutorialsController < ApplicationController
  include Authenticated
  include ConnectorToken

  load_and_authorize_resource :site
  load_and_authorize_resource :tutorial, :through => :site

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

end
