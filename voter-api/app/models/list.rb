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
    face_off_id_pairs = face_offs_for_user(user).map do |face_off|
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
      option_pair_ids = option_pair.map { |option| option.id }.sort
      # option_pair_ids
      #   [1, 3]
      face_off_id_pairs.include?(option_pair_ids)
    end
  end

  def user_has_completed_voting?(user)
    option_count = options.count
    required_face_offs = (option_count * (option_count - 1)) / 2

    face_offs_for_user(user).count == required_face_offs
  end

  def rankings
    scoreboard = options.map do |option|
      {
        :option => option,
        :wins => FaceOff.where(:winner_id => option.id).count
      }
    end.sort_by { |record| record[:wins] }.reverse

    _format_rankings(scoreboard)
  end

  def face_offs_for_user(user)
    FaceOff.where(:user_id => user.id, :list_id => id)
  end

  def all_face_offs
    return @_all_face_offs if defined?(@_all_face_offs)

    @_all_face_offs = FaceOff.where(:list_id => id)

    @_all_face_offs
  end

  def all_users_who_have_completed_voting
    all_face_offs
      .map(&:user)
      .select { |user| user_has_completed_voting?(user) }
  end

  def narrative
    all_face_offs
      .sort { |a,b| a.user.id <=> b.user.id }
      .map do |face_off|
      "#{face_off.user.name} chose #{face_off.winner.label} over #{face_off.loser.label}"
    end
  end

  def narrative_for_user
    narrative
  end

  def _format_rankings(scoreboard)
    rankings = {}
    previous_wins = nil
    previous_rank = nil
    (1..options.length).each do |rank|
      row = scoreboard.shift
      if previous_wins && row[:wins] == previous_wins
        rankings[previous_rank] << row[:option].label
        rankings[previous_rank].sort! { |a,b| a.downcase <=> b.downcase }
      else
        rankings[rank] = [row[:option].label]
        previous_rank = rank
      end

      previous_wins = row[:wins]
    end

    rankings
  end

  def ranking_for_user(user)
    scoreboard = options.map do |option|
      {
        :option => option,
        :wins => FaceOff.where(
          :user_id => user.id,
          :winner_id => option.id
        ).count
      }
    end.sort_by { |record| record[:wins] }.reverse

    _format_rankings(scoreboard)
  end

  def individual_rankings
    rankings = {}
    all_users_who_have_completed_voting.each do |user|
      rankings[user.name] = ranking_for_user(user)
    end

    rankings
  end

  def completed_voting_count
    User
      .find(all_face_offs.map(&:user_id).uniq)
      .select { |user| user_has_completed_voting?(user) }
      .length
  end
end
