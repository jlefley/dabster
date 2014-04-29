Dabster::Engine.routes.draw do
  root 'main#index'
  resources :library_artists, only: [:index]
  resources :library_albums, only: [:show, :index]
  resources :library_items, only: [:show]
  resources :groups, only: [:destroy, :show, :edit, :update, :index]
  resources :artist_library_item_relationships, only: [:create, :index]
  resources :artists, only: [:show]
  resources :playlists, only: [:show]

  get '/playback' => 'playback#index', as: :playback

  post '/playlist/:id/play' => 'playlists#play', as: :play_playlist

  post '/groups/associate_whatcd' => 'groups#associate_whatcd'

  delete '/artist_library_item_relationships' => 'artist_library_item_relationships#destroy'

  get '/library_artists/show' => 'library_artists#show', as: :library_artist
end
