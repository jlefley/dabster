DabsterApp::Application.routes.draw do
  root 'main#index'
  resources :library_artists, only: [:index]
  resources :library_albums, only: [:show, :index]
  resources :library_items, only: [:show]
  resources :groups, only: [:edit, :create, :update, :index, :show]
  resources :artist_library_item_relationships, only: [:create]

  delete '/artist_library_item_relationships' => 'artist_library_item_relationships#destroy'
  get '/library_artists/show' => 'library_artists#show', as: :library_artist
end
