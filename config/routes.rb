require 'resque/server'

PhotoApi::Application.routes.draw do
  get 'ping', to: 'application#ping'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }
  
  #User routes
  resources :users, :only => :none do
    resources :websites, :only => [:index, :create]
    
    resources :posts, :only => :none do
      resources :images, :only => [:index]
    end
  end
  
  
  #websites routes
  resources :websites, :only => [:index] do
    resources :posts, :only => [:index, :show]
  end
  
  resources :posts, :only => :none do
    resources :images, :only => [:index]
  end
  
  

  # resources :images do
  #   collection do 
  #     put 'transfert'
  #     get 'search'
  #   end
  # end

  # resources :zipfiles, :only => [:index]

  # resources :websites do
  #   collection do
  #     get 'search'
  #   end

  #   resources :posts, :only => [:create, :destroy, :update, :index] do
  #     member do
  #       put 'banish'
  #     end

  #     collection do  
  #       get 'search'
  #     end

  #     resources :images, shallow: true do
  #       collection do
  #         delete  'destroy_all'
  #       end
  #     end
  #   end

  #   resources :images, :only => :index do
  #     collection do 
  #       put 'transfert'
  #       get 'search'
  #     end
  #   end
  # end

  mount Resque::Server.new, at: "/resque"
end
