class Appointment < ApplicationRecord
  belongs_to :user
  belongs_to :patient
  belongs_to :report
end
