class UserMailer < ApplicationMailer
  default from: ENV['EMAIL_USER']

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to the Learnify App')
  end

   def welcome_teacher(teacher)
    @teacher = teacher
     @url = 'http://127.0.0.1:3000/'
    mail(to: @teacher.user.email, subject: 'Welcome to Our Platform as a Teacher')
  end
end
