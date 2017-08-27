# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # Static Stuff
  root 'static_pages#home'
  match '/home' => "static_pages#home", via: [:get]
  match '/terms' => "static_pages#terms", via: [:get]
  post '/contact', to: 'static_pages#contact', as: 'contact'

  # The User-facing App
  resource :dashboard, controller: 'dashboard' do
  end
  resources :studio_session_types
  resources :studio_sessions
  resources :coaches

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    invitations: 'users/invitations',
    passwords: 'users/passwords',
  }

  namespace :twilio do
    resources :messages, only: [:create]
  end


  # Admin Space
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
