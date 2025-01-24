class CreateQuizzes < ActiveRecord::Migration[7.2]
  def change
    create_table :quizzes do |t|
      t.timestamps
    end
  end
end
