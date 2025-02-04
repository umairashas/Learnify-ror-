class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses or /courses.json
  def index
    if current_user.role == "teacher"
    @teacher = current_user.teacher # Get the teacher associated with the current user
    @courses = @teacher.courses # Fetch courses added by the teacher
    elsif current_user.role == "student"
    @courses = Course.all # Admins can see all courses
    else
    redirect_to root_path, alert: "You are not authorized to view this page."
    end
  end

  # GET /courses/1 or /courses/1.json
  def show
      @course = Course.find(params[:id])
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit

  # POST /courses or /courses.json
  def create
    if current_user.role == "teacher"
    @teacher = current_user.teacher # Get the teacher associated with the current user
    @course = Course.new(course_params.merge(teacher_id: @teacher.id))
    if @course.save
      redirect_to courses_path, notice: "Course was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
    else
    redirect_to root_path, alert: "You are not authorized to create a course."
    end
  end

  def edit
  @course = Course.find_by(id: params[:id])
  if @course.nil?
    redirect_to courses_path, alert: "Course not found."
  end
end

def update
  @course = Course.find_by(id: params[:id])

  if @course.nil?
    redirect_to courses_path, alert: "Course not found."
    return
  end

  if @course.update(course_params)
    redirect_to course_path(@course), notice: "Course was successfully updated."
  else
    render :edit, status: :unprocessable_entity
  end
end


  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy!

    respond_to do |format|
      format.html { redirect_to courses_path, status: :see_other, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def enroll
    @courses = Course.all.includes(:teacher) # Fetch all courses with their teachers
  end

  # POST /courses/enroll/:id
  def enroll_course
    course = Course.find(params[:id])
    current_user.student.courses << course
    redirect_to enroll_course_path, notice: "Enrolled in #{course.title} successfully!"
  end

  # DELETE /courses/unenroll/:id
  def unenroll_course
    course = Course.find(params[:id])
    current_user.student.courses.delete(course)
    redirect_to enroll_course_path, notice: "Unenrolled from #{course.title} successfully!"
  end

  def enrolled_students
  @course = Course.find(params[:id])
  @students = @course.students  # Assuming a `has_many :students` association
  end


def complete_video
  student_course = StudentCourse.find_by(student_id: current_user.student.id, course_id: params[:id])

  if student_course
    student_course.update(video_completed: true)
    render json: { message: "Video marked as completed!" }
  else
    render json: { error: "StudentCourse record not found" }, status: :not_found
  end
end



def quiz_result
  @course = Course.find_by(id: params[:id])
  # Find the student's quiz attempts
  @quiz_attempts = QuizAttempt.where(student_id: current_user.student.id, quiz_id: @course.quizzes.ids)

  # Calculate the score
  total_questions = @course.quizzes.count
  correct_answers = @quiz_attempts.where('score = ?', 1).count
  percentage_score = (correct_answers.to_f / total_questions) * 100

  # Display the results
  @quiz_result = { answers: correct_answers, total_questions: total_questions, percentage_score: percentage_score }
end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:title, :description, :category, :video, :teacher_id)
    end
end
