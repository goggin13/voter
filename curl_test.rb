require "json"
require "shellwords"

DOMAIN = if ARGV[0] == "local"
  "localhost:3000"
else
  "https://agile-ridge-67293.herokuapp.com"
end

SESSION_ID_1 = "Kelly"
SESSION_ID_2 = "Matt"

def do_command(command)
  puts command
  result = `#{command}`.chomp
  JSON.parse(result)
end

def curl(method, path, session_id, payload=nil)
  command = "curl -s --cookie 'session_id=#{session_id}' -H 'Content-Type: application/json' -X#{method} #{DOMAIN}/#{path}"

  if payload
    command += " -d \"#{payload.to_json.gsub("\"", "\\\"")}\""
  end

  do_command(command)
end

# Create a new list
puts "## Kelly creates a list"
list_params = {
  :list => {
    :name => "Test List",
    :options => {
      "1": {:label => "pizza"},
      "2": {:label => "tacos"},
      "3": {:label => "thai"},
    }
  }
}
list = curl("POST", "lists.json", SESSION_ID_1, list_params)
puts JSON.pretty_generate(list)

puts "## Kelly links her name"
vote = curl("POST", "users/link.json", SESSION_ID_1, { :name => "Kelly" })

puts "## Matt links his name"
vote = curl("POST", "users/link.json", SESSION_ID_2, { :name => "Matt" })

puts "## Kelly votes"
list["face_offs"].each do |pair|
  winner_id, loser_id = [pair[0]["id"], pair[1]["id"]].shuffle

  vote = curl("POST", "/lists/#{list["id"]}/face_offs.json", SESSION_ID_1, {
    :winner_id => winner_id,
    :loser_id => loser_id,
  })
  puts JSON.pretty_generate(vote)
end

puts "## Matt votes"
list["face_offs"].each do |pair|
  winner_id, loser_id = [pair[0]["id"], pair[1]["id"]].shuffle

  vote = curl("POST", "/lists/#{list["id"]}/face_offs.json", SESSION_ID_2, {
    :winner_id => winner_id,
    :loser_id => loser_id,
  })
  puts JSON.pretty_generate(vote)
end

puts "## Kelly views the list with ranksings and description"
reloaded_list = curl("GET", "/lists/#{list["id"]}.json", SESSION_ID_1)
puts JSON.pretty_generate(reloaded_list)
