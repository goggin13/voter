require "json"
require "shellwords"

DOMAIN = if ARGV[0] == "local"
  "localhost:3000"
else
  "https://agile-ridge-67293.herokuapp.com"
end

def do_command(command)
  puts command
  result = `#{command}`.chomp
  JSON.parse(result)
end

def curl(method, path, payload=nil)
  command = "curl -s --cookie 'session_id=a1a806f9b7bbdf69' -H 'Content-Type: application/json' -X#{method} #{DOMAIN}/#{path}"

  if payload
    command += " -d \"#{payload.to_json.gsub("\"", "\\\"")}\""
  end

  do_command(command)
end

# Create a new list
list_params = {
  :list => {
    :name => "Test List",
    :options => [
      {:label => "pizza"},
      {:label => "tacos"},
      {:label => "thai"},
    ]
  }
}
puts "## Create a list"
list = curl("POST", "lists.json", list_params)
puts JSON.pretty_generate(list)
