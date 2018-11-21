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

  def serializable_hash
    list_hash = super
    list_hash[:options] = options.inject([]) do |acc, option|
      acc << option
    end

    list_hash
  end
end
