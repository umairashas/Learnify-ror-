class Course < ApplicationRecord
	has_one_attached :video
	validate :video_size
  has_many :quizzes, dependent: :destroy
  has_many :certificates, dependent: :destroy
  private

  def video_size
    if video.attached? && video.byte_size > 100.megabytes
      errors.add(:video, "is too big. Maximum size allowed is 100MB.")
    end
  end
end
