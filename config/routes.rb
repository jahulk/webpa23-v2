Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users do
    post 'toggle_activity', on: :member
    get 'recommendation', on: :member
  end
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
    get 'active', on: :collection
    get 'retired', on: :collection
  end
  resources :styles do
    get 'about', on: :collection
  end
  resources :ratings, only: [:index, :show, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # get 'styles', to: 'styles#index'
  # get 'styles/:id', to: 'styles#show', as: 'style'
  # get 'ratings', to: 'ratings#index'
  # get 'ratings/new', to:'ratings#new'
  # post 'ratings', to: 'ratings#create'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  get 'places', to: 'places#index'
  post 'places', to: 'places#search'
  get 'beerlist', to: 'beers#list'
  get 'chat', to: 'messages#index'
  post 'messages', to: 'messages#create'
  # Defines the root path route ("/")
  # root "articles#index"
  root 'breweries#index'

end
