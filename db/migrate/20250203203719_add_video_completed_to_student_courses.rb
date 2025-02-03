class AddVideoCompletedToStudentCourses < ActiveRecord::Migration[7.2]
  def change
    add_column :student_courses, :video_completed, :boolean
  end
end
