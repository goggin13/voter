class Option < ApplicationRecord
  belongs_to :list
  validates_presence_of :label
end
