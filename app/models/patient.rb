class Patient < ApplicationRecord
  belongs_to :group
  has_many :notes
  has_many :pathologies, dependent: :destroy
  has_one_attached :photo
  validates :first_name, :last_name, :address, :date_of_birth, presence: true
  
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
end
