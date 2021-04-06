class IntentsController < ApplicationController
   UNIT_PRICE = 15.0

   def create
      Stripe.api_key = Rails.configuration.x.stripe_client_secret

      storage = params[:storage]
      months = params[:months]
      payment_type = params[:payment_type] || 'card'
      my_storage = Storage.find_by user_id: @user.id

      if payment_type == 'card'
         @currency = 'usd'
      elsif payment_type == 'wechat'
         @currency = 'jpy'
      else
         @currency = 'cny'
      end
      if !my_storage.nil? && my_storage.storage != storage
         increased_amount = UNIT_PRICE * storage * months
         current_storage = @user.storage.storage
         stop_seconds = @user.storage.stop_seconds.to_i
         delta_days = (stop_seconds - Time.now.to_i) / (60 * 60 * 24)
         delta_amount = (UNIT_PRICE / 30) * delta_days * (storage - current_storage)
         @amount = increased_amount + delta_amount
      else
         @amount = UNIT_PRICE * storage * months
      end
      if @currency == 'cny'
         @amount = @amount * 7
      elsif @currency == 'jpy'
         @amount = (@amount/100).to_i
      end
      p "@amount2 #{@amount}"

      payment_intent = Stripe::PaymentIntent.create(
         payment_method_types: [payment_type],
         amount: @amount.to_i,
         currency: @currency
      )
      secret = payment_intent['client_secret']
      order = StorageHistory.new
      order.user_id = @user.id
      order.storage = storage
      order.months = months
      order.secret = secret
      order.amount = @amount
      order.currency = @currency
      order.payment_type = payment_type
      if !my_storage.nil? && my_storage.storage != storage
         order.action = StorageHistory::ACTION_CHANGE
      else
         order.action = StorageHistory::ACTION_ADD
      end
      order.save!
      succeed(secret)
   end

   def show
      order = StorageHistory.find_by!(secret: params[:id])
                            .select(:payed, :note)
      succeed order
   end
end
