class SiteTipsController < NestedTipsController

  load_and_authorize_resource :site
  load_and_authorize_resource :tip, through: :site, shallow: true, parent: false

  self.nested_object = :@site

end
