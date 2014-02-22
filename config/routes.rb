PhotoDownloader::Application.routes.draw do
  resources :websites do
    resources :posts, :only => :destroy do
      resources :images do
        member do
          put 'redownload'
        end
        collection do
          delete 'destroy_all'
        end
      end
    end

    resources :images, :only => :index
  end
end
