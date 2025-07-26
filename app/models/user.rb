class User < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :charts, through: :rooms
  has_many :rules, through: :rooms

  validates :name, presence: true, length: { maximum: 255 }
end
