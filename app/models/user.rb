class User < ApplicationRecord
  has_many :rooms, dependent: :destroy
  has_many :charts, through: :rooms
  has_many :rules, through: :rooms
  has_many :room_users, dependent: :destroy
  has_many :participating_rooms, through: :room_users, source: :room

  validates :name, presence: true, length: { maximum: 255 }
end
