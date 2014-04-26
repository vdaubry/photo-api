require 'resque/server'

PhotoDownloader::Application.routes.draw do
  get 'ping', to: 'application#ping'

  #For CORS support
  match "/*path" => "application#options", via: [:options]

  resources :images, shallow: true do
    collection do 
      put 'transfert'
    end
  end

  resources :websites do
    collection do
      get 'search'
    end

    resources :posts, :only => [:create, :destroy, :update] do
      member do
        put 'banish'
      end

      collection do  
        get 'search'
      end

      resources :images do
        collection do
          delete  'destroy_all'
        end
      end
    end

    resources :scrappings, :only => [:create, :update]

    resources :images, :only => :index do
      collection do 
        put 'transfert'
        get 'search'
      end
    end
  end

  mount Resque::Server.new, at: "/resque"
end
