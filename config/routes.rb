Dabster::Application.routes.draw do
  root 'main#index'
  resources :library_artists, only: [:index]
  resources :library_albums, only: [:show]
  resources :groups, only: [:create, :update]

  get '/library_artists/show' => 'library_artists#show', as: :library_artist
end
