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
  resources :admins, except: :destroy, module: 'admin'
  resources :calendars, except: [:show, :edit, :update]
  namespace :admin do
    root 'admins#home'
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    patch 'approve/:id', to: 'bikes#update', as: 'bikes_approve'
    delete 'destroy/:id', to: 'admins#destroy', as: 'destroy'
    resources :bikes, except: :destroy
  end
end
