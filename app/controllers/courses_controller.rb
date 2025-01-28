class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses or /courses.json
  def index
    if current_user.role == 'teacher'
    @teacher = current_user.teacher # Get the teacher associated with the current user
    @courses = @teacher.courses # Fetch courses added by the teacher
  elsif current_user.admin?
    @courses = Course.all # Admins can see all courses
  else
    redirect_to root_path, alert: "You are not authorized to view this page."
  end
  end

  # GET /courses/1 or /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses or /courses.json
  def create
   
    if current_user.role == 'teacher'
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

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
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
