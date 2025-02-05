class UserMailer < ApplicationMailer
  default from: ENV['EMAIL_USER']

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to the Learnify App')
  end
end
