require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :refunds
  resources :ssns, only: [:index]
  resources :settings
  resources :ledger_entries, only: [:index]
  devise_for :users, skip: [:registrations], controllers: { passwords: :passwords}
  scope(path_names: { new: 'signup', edit: 'confirm_signup'}) do
    resources :users do
      collection do
        get 'purchases'        
      end
      member do
      	patch 'update_ssns'
      	get 'edit_ssns'
      	get 'edit_password'
      	patch 'update_password'
      	get 'edit_details'
      	patch 'update_details'
      end

      collection do
	get 'applications'
      end

      collection do
	get 'applications'
      end
    end
  end
  resources :trade_lines do
    resources :purchases
  end
  resources :ssns
  
  get '/purchases', to: 'dashboard#purchases'
  get '/about', to: 'dashboard#about_us'
  get '/contact', to: 'dashboard#contact_us'
  resources :deposits
  resources :banking_informations
  resources :withdraws

  root to: 'dashboard#index'
end
