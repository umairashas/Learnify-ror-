class Quiz < ApplicationRecord
  belongs_to :teacher
  belongs_to :course
    has_many :quiz_attempts
  has_many :students, through: :quiz_attempts
end
