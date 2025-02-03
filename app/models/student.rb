class Student < ApplicationRecord
  belongs_to :user
  has_many :student_courses, dependent: :destroy
    has_many :courses, through: :student_courses
    has_many :quiz_attempts
  has_many :quizzes, through: :quiz_attempts
    has_many :certificates, dependent: :destroy
    validates :name, :email, :phone_number, presence: true
end
