class AddFieldsToStudents < ActiveRecord::Migration[7.2]
  def change
    add_column :students, :name, :string
    add_column :students, :email, :string
    add_column :students, :phone_number, :string
  end
end
