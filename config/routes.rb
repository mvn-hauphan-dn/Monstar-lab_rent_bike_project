Rails.application.routes.draw do
  root 'static_pages#home'
  get 'help', to: 'static_pages#help'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :bikes, except: :destroy
  resources :admins, module: 'admin'
  resources :calendars, except: [:show, :edit, :update]
  namespace :admin do
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    patch 'approve/:id', to: 'bikes#update', as: 'bikes_approve'
    resources :bikes, except: :destroy
  end
end
