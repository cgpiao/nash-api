Rails.application.routes.draw do
   scope "/v1" do
      resources :accounts, only: [:create]
      resources :orders, only: [:index]
      resources :intents, only: [:create, :show]

      namespace :stripe do
         resources :customers, only: [:create]
         resources :cards, only: [:create]
      end
      post 'stripe/hooks', to: 'stripe#hooks'
      get 'account', to: 'accounts#show', as: 'account'
      post 'account/change-plan', to: 'accounts#change_plan'
      post 'login', to: 'accounts#login', as: 'login'
      delete 'logout', to: 'accounts#logout', as: 'logout'
      resources :files, only: [:create, :index, :update, :show]
      put 'hashes/:id/pin', to: 'hashes#create', as: 'pin_by_hash'
      delete 'hashes/:id/unpin', to: 'files#unpin', as: 'unpin'
   end
end
