git push heroku `git subtree split --prefix voter-api master`:master --force
heroku run rails db:migrate
