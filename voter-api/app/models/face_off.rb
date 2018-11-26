class FaceOff < ApplicationRecord
  belongs_to :user
  belongs_to :winner, :class_name => "Option"
  belongs_to :loser, :class_name => "Option"
end
