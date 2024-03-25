# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#home'
  get 'error', to: 'errors#error'
  get 'help', to: 'static_pages#help'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  patch 'cancel/:id', to: 'bikes#cancel', as: 'cancel'
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  resources :bikes, except: :destroy
  resources :admins, except: :destroy, module: 'admin'
  resources :calendars, except: %i[show edit update]
  resources :bookings, except: %i[destroy edit]
  resources :booking_statuses, only: :create do
    post 'booking', on: :collection
    post 'cancel', on: :collection
    post 'payment', on: :collection
    post 'finished', on: :collection
  end
  namespace :admin do
    root 'admins#home'
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    patch 'approve/:id', to: 'bikes#update', as: 'bikes_approve'
    delete 'destroy/:id', to: 'admins#destroy', as: 'destroy'
    resources :bikes, except: :destroy
    resources :categories
    resources :bookings, only: %i[index show]
    resources :users, only: %i[index show]
  end
end
