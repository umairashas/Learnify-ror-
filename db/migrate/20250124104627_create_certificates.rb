class CreateCertificates < ActiveRecord::Migration[7.2]
  def change
    create_table :certificates do |t|
      t.references :student, null: false, foreign_key: true
      t.references :courses, null: false, foreign_key: true
      t.timestamps
    end
  end
end
