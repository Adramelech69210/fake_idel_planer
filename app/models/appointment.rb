class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :patient

  belongs_to :report, optional: true

  validates :date, :start_time, :end_time, presence: true
  validates :start_time, comparison: { less_than: :end_time }
end
