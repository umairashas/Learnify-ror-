class Student < ApplicationRecord
  belongs_to :user
  has_many :student_courses, dependent: :destroy
    has_many :courses, through: :student_courses
    has_many :quiz_attempts
  has_many :quizzes, through: :quiz_attempts
    has_many :certificates, dependent: :destroy
    validates :name, :email, :phone_number, presence: true

  def completed_quizzes?(course)
    total_quizzes = course.quizzes.count
    attempted_quizzes = quiz_attempts.where(quiz_id: course.quizzes.pluck(:id)).distinct.count
    attempted_quizzes == total_quizzes
  end

  def completed_video?(course)
    student_course = StudentCourse.find_by(student_id: id, course_id: course.id)
    student_course&.video_completed == true
  end
end
