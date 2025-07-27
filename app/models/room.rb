class Room < ApplicationRecord
  belongs_to :user
  has_many :charts, dependent: :destroy
  has_many :rules, dependent: :destroy
  has_many :room_users, dependent: :destroy
  has_many :participants, through: :room_users, source: :user

  enum :room_type, { standard: 0, custom: 1 }

  validates :name, presence: true, length: { maximum: 255 }
  validates :limit_point, numericality: { greater_than_or_equal_to: 1 }, allow_nil: true
  validates :limit_round, numericality: { greater_than_or_equal_to: 1 }, allow_nil: true
  validates :room_type, presence: true
end
