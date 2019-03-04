class Option < ApplicationRecord
  belongs_to :list
  validates_presence_of :label

  has_many :winning_face_offs, :class_name => "FaceOff", :foreign_key => "winner_id"
  has_many :losing_face_offs, :class_name => "FaceOff", :foreign_key => "winner_id"
end
