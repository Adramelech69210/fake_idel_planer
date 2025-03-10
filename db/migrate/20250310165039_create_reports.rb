class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.text :text
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
