require 'resque/server'

PhotoApi::Application.routes.draw do
    
  scope '/api/v1' do
    devise_for :users, controllers: {
      sessions: 'api/v1/users/sessions',
      registrations: 'api/v1/users/registrations',
    }
  end
  
  namespace :api do
    namespace :v1 do
      #User routes
      resources :users, :only => :none do
        resources :websites, :only => [:index, :create], :controller => 'users/websites' do
          resources :posts, :only => [:show, :index], :controller => 'users/posts'
        end
      
        resources :posts, :only => :none do
          resources :images, :only => [:index], :controller => 'users/images'
        end
      end
      
      #websites routes
      resources :websites, :only => [:index] do
        resources :posts, :only => [:index, :show]
      end
      
      resources :posts, :only => :none do
        resources :images, :only => [:index]
      end
      
      get 'ping', to: 'base#ping'
    end
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
