class IntentsController < ApplicationController
   UNIT_PRICE = 15.0
   def create
      Stripe.api_key = Rails.configuration.x.stripe_client_secret

      storage = params[:storage]
      months = params[:months]
      my_storage = Storage.find_by user_id: @user.id

      if !my_storage.nil? && my_storage.storage != storage
         increased_amount = UNIT_PRICE * storage * months
         current_storage= @user.storage.storage
         stop_seconds = @user.storage.stop_seconds.to_i
         delta_days = (stop_seconds - Time.now.to_i)/(60 * 60 * 24)
         delta_amount = (UNIT_PRICE/30) * delta_days * (storage - current_storage)
         @amount = increased_amount + delta_amount
      else
         @amount = UNIT_PRICE * storage * months
      end

      payment_intent = Stripe::PaymentIntent.create(
         amount: @amount.to_i,
         currency: 'usd'
      )
      secret = payment_intent['client_secret']
      order = StorageHistory.new
      order.user_id = @user.id
      order.storage = storage
      order.months = months
      order.secret = secret
      order.amount = @amount
      if !my_storage.nil? && my_storage.storage != storage
         order.action = StorageHistory::ACTION_CHANGE
      else
         order.action = StorageHistory::ACTION_ADD
      end
      order.save!
      succeed(secret)
   end
end
