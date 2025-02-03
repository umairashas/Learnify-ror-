class HomesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :about, :contact ]

  def index
    @user = current_user
    @courses = Course.all
    if user_signed_in?
    @enrolled_courses = current_user.student&.courses || []
  else
    @enrolled_courses = []
  end
  end

  def about
  end

  def contact
  end

  def profile
    @user = current_user
    @course = Course.find_by(id: params[:id])
    @teacher = current_user.teacher
    if @teacher
     @unique_students = @teacher.students
    .select("students.id, students.name, students.email, COUNT(DISTINCT courses.id) AS course_count")
    .joins(:courses)
    .group("students.id, students.name, students.email")
    else
      flash[:alert] = "You are not assigned as a teacher."
      redirect_to profile_path
end
  end
end
