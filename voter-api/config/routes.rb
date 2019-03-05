Rails.application.routes.draw do
  resources :options
  resources :lists
  resources :face_offs
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post "users/link", :to => "users#set_user_name"
end
