class NestedTipsController < ApplicationController
  include Authenticated
  include ConnectorToken
  include TipsParams

  class << self
    attr_accessor :nested_object
  end

  def index
    @tips = @tips.sort_by_row_order

    if @tips.blank?
      redirect_to [:new, _obj, :tip]
    else
      render template: 'tips/index'
    end
  end

  def show
    render template: 'tips/show'
  end

  def new
    render template: 'tips/new'
  end

  def create
    @tip.attributes = tip_params
    @tip.tippable   = _obj

    if @tip.save
      redirect_to [_obj, :tips]
    else
      flash.now[:error] = 'There was an error saving your message.'
      render template: 'tips/new'
    end
  end

  def edit
    render template: 'tips/edit'
  end

  def update
    if @tip.update_attributes(tip_params)
      redirect_to [_obj, :tips], :notice => "Message '#{@tip.title}' saved"
    else
      flash.now[:error] = 'There was an error updating your message.'
      render template: 'tips/edit'
    end
  end

  def destroy
    @tip.destroy

    respond_to do |format|
      format.js { render template: 'tips/destroy' }
    end
  end

  protected
    def _obj
      instance_variable_get self.class.nested_object
    end

end
