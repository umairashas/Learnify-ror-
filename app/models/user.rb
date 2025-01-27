class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: {student: 0, teacher: 1, admin: 2}
    validates :role, presence: true
  has_many :students, dependent: :destroy
  has_many :teachers , dependent: :destroy
  after_create :create_associated_record

  private

  def create_associated_record
    case role
    when "teacher"
      Teacher.create(user: self)  # Create Teacher with user_id
    when "student"
      Student.create(user: self)  # Create Student with user_id
    end
  end
end
