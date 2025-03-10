class CreateAppointments < ActiveRecord::Migration[7.1]
  def change
    create_table :appointments do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.references :user, null: false, foreign_key: true
      t.references :patient, null: false, foreign_key: true
      t.text :summary
      t.references :report, null: false, foreign_key: true

      t.timestamps
    end
  end
end
