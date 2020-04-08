Rails.application.routes.draw do
  
  root "admin/dashboard#index"

  devise_for :users
  
  namespace :admin do
    root "dashboard#index"
    resources :services, except: :edit do
      member do
        post "watch"
        delete "unwatch"
      end
    end
    resources :users, except: [:edit, :show]
    resources :organisations, except: :edit
    resources :locations, except: :edit
  end

  namespace :api do
    namespace :v1 do
      resources :services, only: [:show, :index]
    end
  end
end
