class Patient < ApplicationRecord
  belongs_to :group
  has_many :notes, dependent: :destroy
  has_many :pathologies, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many_attached :ordonnances
  validates :first_name, :last_name, :address, :date_of_birth, :phone_number, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def name
    "#{first_name} #{last_name}"
  end
end
