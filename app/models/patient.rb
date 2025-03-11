class Patient < ApplicationRecord
  belongs_to :group

  has_one_attached :photo
end
