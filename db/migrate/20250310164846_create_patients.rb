class CreatePatients < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.string :address
      t.date :date_of_birth
      t.string :social_security_number
      t.string :mutual
      t.string :referring_doctor
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
