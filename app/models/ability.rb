class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, :all

    can [:manage, :general_broadcast], Site
  end
end
