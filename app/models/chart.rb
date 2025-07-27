class Chart < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :rule

  validates :point, presence: true, numericality: true
  validates :round, presence: true, numericality: { greater_than: 0 }

  before_save :calculate_points_from_rule

  private

  def calculate_points_from_rule
    return unless rule_id_changed? || point.nil?

    case rule.point_type
    when "score"
      self.point = rule.point
    when "penalty"
      self.point = -rule.point
    end
  end
end
