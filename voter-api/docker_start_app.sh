# docker run \
#   --name voter-web \
#   -v $HOME/Documents/projects/voter:/var/www/voter \
#   --rm \
#   goggin13/voter

docker run \
  -it \
  -p 3000:3000 \
  --name voter-web \
  -v $HOME/Documents/projects/voter:/var/www/voter \
  --rm \
  goggin13/voter \
  bash
