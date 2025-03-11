class AddGroupToUser < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :group
  end
end
