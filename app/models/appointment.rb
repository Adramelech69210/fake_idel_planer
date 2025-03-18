class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :patient

  belongs_to :report, optional: true

  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true, comparison: { greater_than: :start_time }
end
