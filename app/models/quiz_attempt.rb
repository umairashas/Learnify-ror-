class QuizAttempt < ApplicationRecord
	 belongs_to :student
  belongs_to :quiz

  validates :student_id, presence: true
  validates :quiz_id, presence: true
  validates :answer, presence: true
   def correct?
    answer == quiz.answer
  end
end
