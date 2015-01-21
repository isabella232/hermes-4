class NestedTipsController < ApplicationController
  include Authenticated
  include TipsParams

  before_filter :generate_xd_token, only: %w( new edit )

  class << self
    attr_accessor :nested_object
  end

  def index
    @tips = @tips.sort_by_row_order

    if @tips.blank?
      redirect_to [:new, _obj, :tip]
    else
      render template: 'nested_tips/index'
    end
  end

  def show
    render template: 'nested_tips/show'
  end

  def new
    render template: 'nested_tips/new'
  end

  def create
    @tip.attributes = tip_params
    @tip.tippable   = _obj

    if @tip.save
      redirect_to [_obj, :tips]
    else
      flash.now[:error] = 'There was an error saving your message.'
      render template: 'nested_tips/new'
    end
  end

  def edit
    render template: 'nested_tips/edit'
  end

  def update
    if @tip.update_attributes(tip_params)
      redirect_to [_obj, :tips], notice: "Message '#{@tip.title}' saved"
    else
      flash.now[:error] = 'There was an error updating your message.'
      render template: 'nested_tips/edit'
    end
  end

  def destroy
    @tip.destroy

    respond_to do |format|
      format.js { render template: 'nested_tips/destroy' }
    end
  end

  protected
    def _obj
      instance_variable_get self.class.nested_object
    end

    # This is a token to passed between the #tip-connector and the
    # target web site, to enable the authoring component in it and
    # to authorize communication.
    #
    # TODO: actually use a random token and verify it - for now it
    # is only used to pass the opener scheme to postMessage.
    #
    def generate_xd_token
      @connector_token = "authoring"
    end

end
