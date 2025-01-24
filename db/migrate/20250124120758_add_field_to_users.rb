class AddFieldToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :phone_number, :integer
    add_column :users, :role, :integer
    add_column :users, :name, :string
  end
end
