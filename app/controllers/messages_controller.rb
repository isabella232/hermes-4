# This controller serves JS embed files for external sites.
# The remote site is identified through the HTTP Referer header.
#
class MessagesController < ApplicationController

  before_filter :require_callback
  before_filter :find_site
  before_filter :find_message, only: %w( show update show_tutorial_message )

  skip_before_action :verify_authenticity_token

  # Render all the general messages/broadcasts for a single page
  # Used by hermes.js in the GeneralMessaging class
  #
  def index
    remote_user = (cookies['__hermes_user'] ||= State.ephemeral_user)
    @messages = @site.tips.published.sorted.within(@path).respecting(remote_user)

    render json: render_to_string(template: 'messages/index.json'), callback: @callback
  end

  # Render a single tutorial json object
  # this action is called when a tutorial is already started and it contains
  # a tip that has a different path so we need to change page and retrieve
  # just that tutorial to continue with following tips
  # Used by hermes.js in the Tutorial class
  #
  def tutorial
    @tutorials = Tutorial.where(id: params[:tutorial_id])
    head :not_found and return unless @site.user == @tutorials[0].site.user

    render json: render_to_string(template: 'messages/tutorial.json'), callback: @callback
  end

  # Render a tutorials wrapper json object
  #
  # This object has 3 properties: 
  # * tutorials_to_view => tutorials that user still needs to view 
  # * tutorials_already_viewed => tutorials that user has already viewed
  # * tutorials_with_selector => tutorials that will be started just by clicking an element
  #                              inside the page (so they won't be displayed on the tutorials list)
  # Used by hermes.js in the TutorialsManager class
  #
  def tutorials
    remote_user = (cookies['__hermes_user'] ||= State.ephemeral_user)

    @tutorials_to_view = @site.tutorials.published.noselector.within(@path).respecting(remote_user)
    @tutorials_already_viewed = @site.tutorials.published.noselector.within(@path).not_respecting(remote_user)
    @tutorials_with_selector = @site.tutorials.published.withselector.within(@path)

    render json: render_to_string(template: 'messages/tutorials.json'), callback: @callback
  end

  # Render a single tip, bypassing the State machinery, for preview purposes.
  # Used by hermes.js in the Preview class, linked from the tips/_tip
  # partial in the backend interface.
  #
  def show
    json = render_to_string partial: 'messages/message', object: @message
    render json: json, callback: @callback
  end

  # Render a single tutorial tip, bypassing the State machinery, for preview purposes.
  # Used by hermes.js in the Preview class, linked from the tips/_tip
  # partial in the backend interface.
  #
  def show_tutorial_message
    json = render_to_string partial: 'messages/message', object: @message
    render json: json, callback: @callback
  end

  # Updates the status of the given message type and ID for the hermes_user
  # stored in the cookies.
  #
  # params[:until] is expected to be a JS timestamp, that is - milliseconds
  # passed after the Unix Epoch.
  #
  def update
    remote_user = cookies['__hermes_user']
    head :bad_request and return unless remote_user.present?

    up_to = if params[:until].present?
      Time.at(params[:until].to_i / 1000)
    end

    status = @message.dismiss!(remote_user, up_to) ? :created : :ok
    render json: {}, callback: @callback, :status => status
  end

  protected

    def require_callback
      @callback = params[:callback]
      head :bad_request unless @callback.present?
    end

    def find_site
      head :bad_request and return unless request.referer.present?

      @source = URI.parse(request.referer)
      head :bad_request and return unless @source.scheme.in? %w( http https )
      full_site_ref = [@source.scheme, '://', params[:site_ref]].join()
      path = request.referer.include?(full_site_ref) ? request.referer.sub!(full_site_ref, '') : @source.path
      @path = path == '' ? '/' : path.split('?')[0]

      head :bad_request unless @site = Site.where(hostname: params[:site_ref]).first

    rescue URI::InvalidURIError
      head :bad_request
    end

    def find_message
      head :bad_request and return unless params.values_at(:type, :id).all?(&:present?)
      model = params[:type].camelize.constantize

      head :bad_request and return unless model.included_modules.include?(Publicable)
      @message = model.find(params[:id])
    end

end
