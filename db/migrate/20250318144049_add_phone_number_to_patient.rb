class AddPhoneNumberToPatient < ActiveRecord::Migration[7.1]
  def change
    add_column :patients, :phone_number, :string
  end
end
