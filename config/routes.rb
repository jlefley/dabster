DabsterApp::Application.routes.draw do
  root 'main#index'
  resources :library_artists, only: [:index]
  resources :library_albums, only: [:show, :index]
  resources :library_items, only: [:show]
  resources :groups, only: [:edit, :update, :index, :show]
  resources :artist_library_item_relationships, only: [:create]

  post '/groups/associate_what_cd' => 'groups#associate_what_cd'
  delete '/artist_library_item_relationships' => 'artist_library_item_relationships#destroy'
  get '/library_artists/show' => 'library_artists#show', as: :library_artist
end
