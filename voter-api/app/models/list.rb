class List < ApplicationRecord
  has_many :options

  def self.build_from_params(params)
    options = params.delete(:options)
    list = List.new(params)
    options.each do |option|
      list.options.build(:label => option[:label])
    end

    list
  end

  def remaining_face_offs(user)
    options.to_a.combination(2).to_a
  end
end
