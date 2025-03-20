class Patient < ApplicationRecord
  belongs_to :group
  has_many :notes, dependent: :destroy
  has_many :pathologies, dependent: :destroy
  has_many :appointments, dependent: :destroy
  has_many_attached :ordonnances
  validates :first_name, :last_name, :address, :date_of_birth, :phone_number, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  before_save :override_phone_number

  def name
    "#{first_name} #{last_name}"
  end

  def override_phone_number
    cleaned = self.phone_number.gsub(/\D/, '') # Remove non-digit characters

    # Handle different cases: with or without country code
    if cleaned.start_with?('33') && cleaned.length == 11
      self.phone_number = "+33 #{cleaned[2]} #{cleaned[3..4]} #{cleaned[5..6]} #{cleaned[7..8]} #{cleaned[9..10]}"
    elsif cleaned.start_with?('0') && cleaned.length == 10
      self.phone_number = "#{cleaned[0..1]} #{cleaned[2..3]} #{cleaned[4..5]} #{cleaned[6..7]} #{cleaned[8..9]}"
    end
  end
end
