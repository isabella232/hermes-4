class TutorialTipsController < NestedTipsController

  load_resource :tutorial
  load_and_authorize_resource :tip, through: :tutorial, shallow: true, parent: false

  before_filter :set_site

  self.nested_object = :@tutorial

  protected
    def set_site
      @site = @tutorial.site
    end

end
