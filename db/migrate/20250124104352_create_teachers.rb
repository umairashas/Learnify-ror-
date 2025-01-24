class CreateTeachers < ActiveRecord::Migration[7.2]
  def change
    create_table :teachers do |t|
      t.timestamps
    end
  end
end
