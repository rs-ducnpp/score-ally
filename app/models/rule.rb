class Rule < ApplicationRecord
  belongs_to :room
  has_many :charts, dependent: :destroy

  enum :point_type, { score: 0, penalty: 1 }

  validates :point_type, presence: true
  validates :point, numericality: { greater_than_or_equal_to: 1 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
end
