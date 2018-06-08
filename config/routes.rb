Rails.application.routes.draw do
  resources :reports, except: [:show] do
    member do
      get :approve
    end
  end
  resources :admin, only: [:index, :show, :destroy]
  devise_for :users
  root 'home#index'
  get 'home/about'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end