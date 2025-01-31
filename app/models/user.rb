class User < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_one :student, dependent: :destroy
  has_one :teacher, dependent: :destroy
  enum role: { student: 0, teacher: 1 }

  # Callback to create a student record after user creation
  after_create :create_student_record
  
  private

  def create_student_record
    if role == 'teacher'
      Teacher.create(user_id: id)
    end
    if role == 'student'
      Student.create(name: name, email: email, phone_number: phone_number, user_id: id)
    end
  end
end
