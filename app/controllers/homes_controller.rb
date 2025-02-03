class HomesController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :about, :contact ]

  def index
    @courses = Course.all
    # if current_user.role == 'teacher'
    #   @teacher = current_user.teacher
    #   @course = @teacher.courses # Fetch the first course for the teacher (or use another logic)
    # end
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
