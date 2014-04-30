Dabster::Engine.routes.draw do
  root 'main#index'

  resources :library_artists, only: [:index]
  get '/library_artists/show' => 'library_artists#show', as: :library_artist

  resources :library_albums, only: [:show, :index]

  resources :library_items, only: [:show]

  resources :groups, only: [:destroy, :show, :edit, :update, :index] do
    collection do
      post :associate_whatcd
    end
  end

  resources :artist_library_item_relationships, only: [:create, :index]
  delete '/artist_library_item_relationships' => 'artist_library_item_relationships#destroy'

  resources :artists, only: [:show] do
    member do
      post :start_playlist
    end
  end

  resources :playlists, only: [:show] do
    member do
      post :play
    end
  end

  resource :playback, only: [:show], controller: :playback
end
