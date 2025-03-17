class Report < ApplicationRecord
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :dates_are_valid

  private

  def dates_are_valid
    if start_date.present? && end_date.present? && start_date > end_date
      errors.add(:start_date, "ne peut pas être postérieure à la date de fin.")
    end
  end
end
