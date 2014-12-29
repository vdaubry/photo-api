require 'resque/server'

PhotoApi::Application.routes.draw do
  get 'ping', to: 'application#ping'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }
  
  resources :users, :only => :none do
    resources :websites, :only => [:index, :create] do
    end
  end
  
  
  
  
  #####
  #
  # A RELIRE 
  #
  #####

  resources :images do
    collection do 
      put 'transfert'
      get 'search'
    end
  end

  resources :zipfiles, :only => [:index]

  resources :websites do
    collection do
      get 'search'
    end

    resources :posts, :only => [:create, :destroy, :update, :index] do
      member do
        put 'banish'
      end

      collection do  
        get 'search'
      end

      resources :images, shallow: true do
        collection do
          delete  'destroy_all'
        end
      end
    end

    resources :images, :only => :index do
      collection do 
        put 'transfert'
        get 'search'
      end
    end
  end

  mount Resque::Server.new, at: "/resque"
end
