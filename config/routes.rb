DabsterApp::Application.routes.draw do
  root 'main#index'
  resources :library_artists, only: [:index]
  resources :library_albums, only: [:show, :index]
  resources :library_items, only: [:show]
  resources :groups, only: [:edit, :update]
  resources :artist_library_item_relationships, only: [:create]
  resources :artists, only: [:show]

  post '/groups/associate_whatcd' => 'groups#associate_whatcd'
  delete '/artist_library_item_relationships' => 'artist_library_item_relationships#destroy'
  get '/library_artists/show' => 'library_artists#show', as: :library_artist
end
