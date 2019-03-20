class FaceOff < ApplicationRecord
  validates_presence_of :winner_id
  validates_presence_of :loser_id
  validates_presence_of :user_id
  validates_presence_of :list_id

  belongs_to :user
  belongs_to :winner, :class_name => "Option"
  belongs_to :loser, :class_name => "Option"
  belongs_to :list
end
