DabsterApp::Application.routes.draw do
  root 'main#index'
  resources :library_artists, only: [:index]
  resources :library_albums, only: [:show, :index]
  resources :groups, only: [:edit, :create, :update, :index, :show]

  get '/library_artists/show' => 'library_artists#show', as: :library_artist
end
