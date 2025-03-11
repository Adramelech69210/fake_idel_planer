class Patient < ApplicationRecord
  belongs_to :group
  validates :first_name, :last_name, :address, :date_of_birth, presence: true
end
