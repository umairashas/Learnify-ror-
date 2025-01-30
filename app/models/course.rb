class Course < ApplicationRecord
	has_one_attached :video
	validate :video_size
  belongs_to :teacher
  has_many :quizzes, dependent: :destroy
  has_many :certificates, dependent: :destroy
  has_many :student_courses
  has_many :students, through: :student_courses 
  private

  def video_size
    if video.attached? && video.byte_size > 100.megabytes
      errors.add(:video, "is too big. Maximum size allowed is 100MB.")
    end
  end
end
