module ConnectorToken
  extend ActiveSupport::Concern

  included do
    before_filter :generate_connector_token, only: %w( new edit )
  end

  protected

    # This is a token to passed between the #tip-connector and the
    # target web site, to enable the authoring component in it and
    # to authorize communication.
    #
    # TODO: actually use a random token and verify it - for now it
    # is only used to pass the opener scheme to postMessage.
    #
    def generate_connector_token
      @connector_token = "authoring-#{self.class.name.underscore}"
    end
end
