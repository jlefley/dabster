Dabster::Application.routes.draw do
  root 'main#index'
  resources :library_artists, only: [:index]
  resources :artists, only: [:new]

  post '/what-artist-request' => 'what#request_artist', as: 'what_artist_request'
end
