class HomesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :about, :contact]

  def index
    if current_user.role == 'teacher'
      @teacher = current_user.teacher
      @course = @teacher.courses # Fetch the first course for the teacher (or use another logic)
    end
  end

  def about
  end

  def contact
  end

  def profile
    @user = current_user
  end

end
