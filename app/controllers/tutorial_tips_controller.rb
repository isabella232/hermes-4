class TutorialTipsController < NestedTipsController

  load_resource :tutorial
  load_and_authorize_resource :tip, through: :tutorial, shallow: true, parent: false

  self.nested_object = :@tutorial

end
