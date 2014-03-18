PhotoDownloader::Application.routes.draw do
  resources :websites do
    collection do
      get 'search'
    end

    resources :posts, :only => [:create, :destroy, :update] do
      collection do  
        get 'search'
      end

      resources :images do
        member do
          put 'redownload'
        end
        collection do
          delete 'destroy_all'
        end
      end
    end

    resources :scrappings, :only => [:create, :update]

    resources :images, :only => :index do
      collection do  
        get 'search'
      end
    end
  end
end
