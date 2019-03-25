json.extract! list, :id, :name, :user_id
json.url list_url(list, format: :json)
json.options(list.options) do |option|
  json.label option.label
  json.id option.id
end
json.face_offs(list.remaining_face_offs(@current_user).shuffle) do |option_pair|
  json.array! option_pair.shuffle.map do |option|
    json.id option.id
    json.label option.label
  end
end

if list.user_has_completed_voting?(@current_user)
  json.rankings list.rankings
  json.narrative list.narrative_for_user
  json.individual_rankings list.individual_rankings
  json.completed_voting_count list.completed_voting_count
end
