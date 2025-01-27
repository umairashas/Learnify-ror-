class Teacher < ApplicationRecord
	belongs_to :user
	has_many :student, through: :courses
	has_many :courses, dependent: :destroy
	has_many :quizzes, dependent: :destroy
end
