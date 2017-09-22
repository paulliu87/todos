Rails.application.routes.draw do
  get 'home/index'

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  put '/users/:user_id/todos/:id/completed', to: 'todos#completed'
  put '/users/:user_id/todos/:id/uncompleted', to: 'todos#uncompleted'
  # get '/users/:user_id/todos/search', to: 'todos#search'
  root 'home#index'
  resources :users do
      resources :todos
  end
  resources :sessions

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
