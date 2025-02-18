class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present? # Guest users have no access

    if user.student?
      can :read, Course
      can :read, Quiz
      can :enroll, Course
      can :read, :student_dashboard 
    elsif user.teacher?
      can :manage, Course
      can :manage, Quiz
      can :read, Student
      can :read, Teacher 
      can :read, :teacher_dashboard # Allow teacher dashboard access
    elsif user.admin?
      can :manage, :all
    end
  end
end
