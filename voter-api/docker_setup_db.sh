docker exec \                
  voter-web \         
  bundle exec rake db:create 
                             
docker exec \                
  voter-web \         
  undle exec rake db:migrate
