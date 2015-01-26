class TutorialTipsController < NestedTipsController

  load_resource :tutorial

  before_filter :load_and_authorize_tips,  only: :index
  before_filter :load_and_authorize_tip, except: :index

  before_filter :set_site

  self.nested_object = :@tutorial

  protected
    def set_site
      @site = @tutorial.site
    end

end
