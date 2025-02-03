class StudentCourse < ApplicationRecord
  belongs_to :student
  belongs_to :course
   after_initialize :set_default_video_completed, if: :new_record?

  private

  def set_default_video_completed
    self.video_completed ||= false
  end
end
