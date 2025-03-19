class ChangeColumnAppointments < ActiveRecord::Migration[7.1]
  def change
    remove_column :appointments, :start_date
    remove_column :appointments, :end_date
    add_column :appointments, :date, :date
    add_column :appointments, :start_time, :time
    add_column :appointments, :end_time, :time
  end
end
