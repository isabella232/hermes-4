class SiteTipsController < NestedTipsController

  load_and_authorize_resource :site

  before_filter :load_and_authorize_tips,  only: :index
  before_filter :load_and_authorize_tip, except: :index

  self.nested_object = :@site

end
