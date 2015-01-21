class TipsController < ApplicationController
  include Authenticated

  load_and_authorize_resource :tip, only: :position

  # Sets the given tip position
  def position
    @tip = Tip.find(params[:id])

    head :bad_request and return unless params[:pos]
    pos = params[:pos].to_i

    head :bad_request and return unless pos >= 0

    @tip.position = pos
    @tip.save!

    head :ok
  end
end
