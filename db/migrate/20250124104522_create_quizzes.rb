class CreateQuizzes < ActiveRecord::Migration[7.2]
  def change
    create_table :quizzes do |t|
      t.string :question
      t.references :teacher, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.string :option_a, null: false
      t.string :option_b, null: false
      t.string :option_c, null: false
      t.string :option_d, null: false
      t.string :answer, null: false
      t.timestamps
    end
  end
end
