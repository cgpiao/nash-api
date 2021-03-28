Rails.application.routes.draw do
   scope "/v1" do
      resources :accounts, only: [:create]
      post 'login', to: 'accounts#login', as: 'login'
      delete 'logout', to: 'accounts#logout', as: 'logout'
      resources :files, only: [:create, :index, :update, :show]
      put 'hashes/:id/pin', to: 'hashes#create', as: 'pin_by_hash'
      delete 'hashes/:id/unpin', to: 'files#unpin', as: 'unpin'
   end
end
