Dabster::Application.routes.draw do
  root 'main#index'
  resources :library_artists, only: [:index]
  resources :library_albums, only: [:show]
  resources :artists, only: [:new]

  post '/what_request' => 'what#make_request', as: 'what_request'
  get '/library_artists/show' => 'library_artists#show', as: :library_artist
end
