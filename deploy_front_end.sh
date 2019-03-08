AWS_ACCESS_KEY_ID = File.read(".aws_access_key_id").chomp
AWS_SECRET_ACCESS_KEY = File.read(".aws_secret_access_key").chomp

command = "AWS_ACCESS_KEY_ID=#{AWS_ACCESS_KEY_ID} AWS_SECRET_ACCESS_KEY=#{AWS_SECRET_ACCESS_KEY} aws s3 cp voter-front/ s3://voter-front-end/ --acl public-read --recursive --cache-control no-cache"
puts command
puts `#{command}`
