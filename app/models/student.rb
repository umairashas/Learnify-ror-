class Student < ApplicationRecord
	belongs_to :user
	has_many :teachers, through: :courses
	has_many :courses, dependent: :destroy
    has_many :quizzes, dependent: :destroy
    has_many :certificates, dependent: :destroy

end
