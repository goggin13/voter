# docker run \
#   -it \
#   --name voter-web \
#   -v /Users/mgoggin/Documents/projects/voter:/var/www/voter \
#   --rm \
#   goggin13/voter \
#   bash

docker run \
  -it \
  -p 3000:3000 \
  --name voter-web \
  -v /Users/mgoggin/Documents/projects/voter:/var/www/voter \
  --rm \
  goggin13/voter \
  bash
