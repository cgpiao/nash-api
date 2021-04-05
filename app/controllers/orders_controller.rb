class OrdersController < ApplicationController
   def index
      succeed @user.storage_histories
   end
end
