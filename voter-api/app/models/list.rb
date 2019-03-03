class List < ApplicationRecord
  has_many :options
  validates_presence_of :name
  validates_presence_of :user_id

  def self.build_from_params(params)
    options = params.delete(:options).values
    list = List.new(params)
    options.each do |option|
      list.options.build(:label => option[:label])
    end

    list
  end

  def remaining_face_offs(user)
    face_off_id_pairs = face_offs(user).map do |face_off|
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

  def user_has_completed_voting?(user)
    option_count = options.count
    required_face_offs = (option_count * (option_count - 1)) / 2

    face_offs(user).count == required_face_offs
  end

  def rankings(user)
    return {} unless user_has_completed_voting?(user)

    records = face_offs(user).inject({}) do |acc, face_off|
      acc[face_off.winner_id] ||= {w: 0, l: 0}
      acc[face_off.winner_id][:w] += 1
      acc[face_off.loser_id] ||= {w: 0, l: 0}
      acc[face_off.loser_id][:l] += 1

      acc
    end.sort_by { |option_id, record| record[:l] }

    rankings = {}
    previous_wins = nil
    (1..options.length).each do |rank|
      option_id, record = records.shift
      if previous_wins && record[:w] == previous_wins
        lowest_reached_rank = rankings.keys.sort.first
        rankings[lowest_reached_rank] << Option.find(option_id)
      else
        rankings[rank] = [Option.find(option_id)]
      end

      previous_wins = record[:w]
    end

    rankings
  end

  def face_offs(user)
    option_ids = options.map(&:id)
    FaceOff.where(
      :user_id => user.id,
      :loser_id => option_ids,
      :winner_id => option_ids
    )
  end
end
