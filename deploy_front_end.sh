#!/Users/goggin/.rvm/rubies/ruby-2.4.2/bin/ruby
AWS_ACCESS_KEY_ID = File.read(".aws_access_key_id").chomp
AWS_SECRET_ACCESS_KEY = File.read(".aws_secret_access_key").chomp

File.readlines("voter-front/helpers.js").grep(/var HOST = .*localhost:3000/).each do |line|
  unless line.strip.match(/^\/\/.*/)
    puts "CANCELLING DEPLOY, uncommented 'HOST=localhost'"
    puts line
    abort
  end
end

command = "AWS_ACCESS_KEY_ID=#{AWS_ACCESS_KEY_ID} AWS_SECRET_ACCESS_KEY=#{AWS_SECRET_ACCESS_KEY} aws s3 cp voter-front/ s3://voter-front-end/ --acl public-read --recursive --cache-control no-cache"
puts command
puts `#{command}`
