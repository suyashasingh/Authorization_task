class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == "Admin"
      can :manage, :all
    elsif user.role == "Candidate"
      can :read, User, id: user.id
      can :read, JobApplication, user_id: user.id
    end
  end
end
