class QuizzesController < ApplicationController
before_action :set_quiz, only: %i[show edit update destroy attempt submit]
before_action :set_course
  # GET /quizzes
  def index
    if current_user.role == "teacher"
      @teacher = current_user.teacher
      @course = @teacher.courses.find_by(id: params[:course_id]) # Ensure only quizzes for the correct course are fetched
      if @course.nil?
        redirect_to courses_path, alert: "Course not found. Please select a valid course."
        return
      end
      @quizzes = @course.quizzes # Ensure plural form to fetch all quizzes for this course
    else
      @quizzes = Quiz.all # Admins or other roles can see all quizzes
    end
  end

  # GET /quizzes/1
  def show
    @course = @quiz.course
    @quizzes = @course.quizzes # Fetch only quizzes belonging to this course
  end

  # GET /quizzes/new
  def new
    if current_user.role == "teacher"
      @teacher = current_user.teacher
      @course = @teacher.courses.find_by(id: params[:course_id]) # Ensure correct course is fetched
      if @course.nil?
        redirect_to courses_path, alert: "Course not found. Please select a valid course."
        return
      end
      @quiz = @course.quizzes.new # Use plural form to create a new quiz for the course
    else
      redirect_to root_path, alert: "You are not authorized to create a quiz."
    end
  end

  # POST /quizzes
  def create
    if current_user.role == "teacher"
      @teacher = current_user.teacher
      @course = @teacher.courses.find_by(id: params[:quiz][:course_id]) # Ensure correct course

      if @course.nil?
        redirect_to courses_path, alert: "Course not found. Please select a valid course."
        return
      end

      @quiz = @course.quizzes.build(quiz_params) # Use plural to associate correctly

      respond_to do |format|
        if @quiz.save
          format.html { redirect_to course_quizzes_path(@quiz.course), notice: "Quiz was successfully created." }
          format.json { render :show, status: :created, location: @quiz }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @quiz.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, alert: "You are not authorized to create a quiz."
    end
  end

  # GET /quizzes/1/edit
  def edit
    @course = @quiz.course
  end

  # PATCH/PUT /quizzes/1
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

  # DELETE /quizzes/1
  def destroy
    @quiz.destroy!

    respond_to do |format|
      format.html { redirect_to course_quizzes_path(@quiz.course), status: :see_other, notice: "Quiz was successfully destroyed." }
      format.json { head :no_content }
    end
  end

    def attempt
       @course = @quiz.course# This action will render the quiz form for the student to attempt
    end

   # In your QuizzesController
 def submit
  @course = Course.find(params[:course_id])
  total_questions = @course.quizzes.count
  answers = 0

  student = current_user.student
  student_course = StudentCourse.find_or_create_by(student_id: student.id, course_id: @course.id)

  # Ensure the student can take the quiz only once
  if student.quiz_attempts.where(quiz_id: @course.quizzes.pluck(:id)).exists?
    flash[:alert] = "You have already completed this quiz."
    redirect_to course_path(@course) and return
  end

  # Process answers and calculate correct ones
  @course.quizzes.each do |quiz|
    answer = params["answer_#{quiz.id}"]

    if answer.present?
      QuizAttempt.create(student_id: student.id, quiz_id: quiz.id, answer: answer, score: (answer == quiz.answer ? 1 : 0))
      answers += 1 if answer == quiz.answer
    else
      flash[:alert] = "You did not answer all the questions. Please try again."
      redirect_to attempt_course_quiz_path(@course, quiz) and return
    end
  end

  percentage_score = (answers.to_f / total_questions) * 100
  flash[:notice] = "Quiz submitted successfully! Your score: #{answers}/#{total_questions} (#{percentage_score.round(2)}%)"

  # Redirect back to the course page instead of generating the certificate
  redirect_to course_path(@course)
end





   def quiz_statistics
    @quizzes = @course.quizzes.includes(:quiz_attempts)
    
    @student_attempts = QuizAttempt.joins(:quiz)
                                   .where(quiz: @quizzes)
                                   .group(:student_id)
                                   .count

    @students_passed = QuizAttempt.joins(:quiz)
                                  .where(quiz: @quizzes)
                                  .where("quiz_attempts.answer = quizzes.answer")
                                  .group(:student_id)
                                  .count
  end


   
  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def quiz_params
    params.require(:quiz).permit(:question, :option_a, :option_b, :option_c, :option_d, :answer, :teacher_id, :course_id) # Ensure course_id is permitted
  end
end
