class AddScoreToQuizAttempts < ActiveRecord::Migration[7.2]
  def change
    add_column :quiz_attempts, :score, :integer
  end
end
