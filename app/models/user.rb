class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :group, optional: true
  has_one_attached :photo

  def picture_url
    if self.photo.attached?
      photo.url
    else
      "https://ui-avatars.com/api/?name=#{first_name} #{last_name}&size=64"
    end
  end
end
