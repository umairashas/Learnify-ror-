class Quiz < ApplicationRecord
	belongs_to :student
	belongs_to  :teacher
	belongs_to :course
end
