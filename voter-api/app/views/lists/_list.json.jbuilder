json.extract! list, :id, :name, :user_id
json.url list_url(list, format: :json)
json.options(list.options) do |option|
  json.label option.label
  json.id option.id
end
json.face_offs(list.remaining_face_offs(@current_user)) do |option_pair|
  json.array! option_pair.map do |option|
    json.id option.id
    json.label option.label
  end
end
json.rankings list.rankings(@current_user)
json.narrative list.narrative_for_user(@current_user)
json.completed_voting_count list.completed_voting_count(@current_user)
