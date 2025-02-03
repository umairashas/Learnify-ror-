class CreateQuizAttempts < ActiveRecord::Migration[7.2]
  def change
    create_table :quiz_attempts do |t|
      t.bigint :student_id
      t.bigint :quiz_id
      t.string :answer

      t.timestamps
    end
  end
end
