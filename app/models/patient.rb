class Patient < ApplicationRecord
  belongs_to :group
  has_many :notes
  has_many :pathologies

  has_one_attached :photo
  validates :first_name, :last_name, :address, :date_of_birth, presence: true
end
