class StudentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :check_student
  before_action :set_student, only: %i[show edit update destroy]

  # Skip CanCan authorization for student_dashboard
  skip_authorize_resource only: :student_dashboard

  def index
    @students = Student.all
  end

  def student_dashboard
    @user = current_user
    @courses = Course.all
    @enrolled_courses = current_user.student&.courses || []
    @student = current_user.student
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @student = Student.new
  end

  def edit
  end

  def create
    @student = Student.new(student_params)
    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: "Student was successfully created." }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @student.destroy!
    respond_to do |format|
      format.html { redirect_to students_path, status: :see_other, notice: "Student was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def check_student
    redirect_to root_path, alert: "Access denied!" unless current_user.student?
  end

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.fetch(:student, {})
  end
end