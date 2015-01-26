class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :manage, Tutorial, site_id: user.site_ids

      can [:manage, :general_broadcast], Site, user_id: user.id
      can [:manage, :position], Tip, id: user.tip_ids
    end
  end

end
