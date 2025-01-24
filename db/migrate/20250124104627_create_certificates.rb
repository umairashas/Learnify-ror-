class CreateCertificates < ActiveRecord::Migration[7.2]
  def change
    create_table :certificates do |t|
      t.timestamps
    end
  end
end
