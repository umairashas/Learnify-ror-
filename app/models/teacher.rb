class Teacher < ApplicationRecord
  belongs_to :user
  has_many :courses, dependent: :destroy
  has_many :students, through: :courses
  has_many :quizzes, dependent: :destroy
end
