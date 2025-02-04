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
  @teacher = current_user.teacher
  
  if @teacher
    # Get students for the teacher and their course count
    @unique_students = @teacher.students
                                .select("students.id, students.name, students.email, COUNT(DISTINCT courses.id) AS course_count")
                                .joins(:courses)
                                .group("students.id, students.name, students.email")
  elsif current_user.student?
    # Handle student profile (You can add student-specific logic here)
    @unique_students = [] # Empty array as students don't have teachers to show
  else
    flash[:alert] = "You are not assigned as a teacher."
    redirect_to root_path # Redirect to a more appropriate path (e.g., the home page or dashboard)
  end
end

end
