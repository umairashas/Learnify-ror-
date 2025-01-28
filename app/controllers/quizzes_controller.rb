class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[ show edit update destroy ]

  # GET /quizzes or /quizzes.json
  def index
      if current_user.role == 'teacher'
    @teacher = current_user.teacher
    @quizzes = Quiz.where(teacher: @teacher) # Show only quizzes created by the current teacher
  else
    @quizzes = Quiz.all # Admins or other roles can see all quizzes
  end 
  end

  # GET /quizzes/1 or /quizzes/1.json
  def show
  end

  # GET /quizzes/new
  def new
  @teacher = current_user.teacher
  @quiz = Quiz.new(course: @course, teacher: @teacher)
  end

  # GET /quizzes/1/edit
  def edit
  end

  # POST /quizzes or /quizzes.json
  def create
    if current_user.role == 'teacher'
    @teacher = current_user.teacher 
    @course = @teacher.courses.find(params[:quiz][:course_id]) 
    end
    @quiz = Quiz.new(quiz_params)
    @quiz = @course.quizzes.build(quiz_params) # Associate quiz with the course
    @quiz.teacher = @teacher
    @quiz.course = @course 
    respond_to do |format|
      if @quiz.save
        format.html { redirect_to @quiz, notice: "Quiz was successfully created." }
        format.json { render :show, status: :created, location: @quiz }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quizzes/1 or /quizzes/1.json
  def update
    respond_to do |format|
      if @quiz.update(quiz_params)
        format.html { redirect_to @quiz, notice: "Quiz was successfully updated." }
        format.json { render :show, status: :ok, location: @quiz }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quiz.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quizzes/1 or /quizzes/1.json
  def destroy
    @quiz.destroy!

    respond_to do |format|
      format.html { redirect_to quizzes_path, status: :see_other, notice: "Quiz was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiz
      @quiz = Quiz.find(params[:id])
    end

   

    # Only allow a list of trusted parameters through.
    def quiz_params
      params.require(:quiz).permit(:question, :option_a, :option_b, :option_c, :option_d, :answer, :teacher_id, :course_id)
    end
end
