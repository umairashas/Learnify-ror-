class HomesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :about, :contact]

  def index
  end

  def about
  end

  def contact
  end

end
