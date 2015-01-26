class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, Tutorial, site_id: user.site_ids

    can [:manage, :general_broadcast], Site, user_id: user.id
    can [:manage, :position], Tip
  end
end
