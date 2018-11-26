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
    option_ids = options.map(&:id)
    face_off_id_pairs = FaceOff.where(
      :user_id => user.id,
      :loser_id => option_ids,
      :winner_id => option_ids
    ).map do |face_off|
      [face_off.winner.id, face_off.loser.id].sort
    end

    # face off pairs
    #   is list of existing [winner, loser] pairs
    #   each pair of integers is sorted ascending
    #      e.g. [3, 1].sort => [1,3]

    all_possible_combinations = options.to_a.combination(2).to_a
    #   is a list of pairs of option objects
    #      e.g. [Option("tacos"), Option("Pizza")]

    all_possible_combinations.reject do |option_pair|
      option_pair_ids = option_pair.map { |obj| obj.id }.sort
      # option_pair_ids
      #   [1, 3]
      face_off_id_pairs.include?(option_pair_ids)
    end
  end
end
