class Chart < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :rule
end
