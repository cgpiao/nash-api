class StripeController < ApplicationController
   def delta

   end
   def hooks
      payload = request.body.read
      event = nil

      begin
         event = Stripe::Event.construct_from(
            JSON.parse(payload, symbolize_names: true)
         )
      rescue JSON::ParserError => e
         # Invalid payload
         status 400
         return
      end

      payment_intent = event.data.object
      p "hooks: #{event.type}"
      case event.type
         #  payment_intent.succeeded, charge.succeeded
      when 'payment_intent.succeeded'
         order = StorageHistory.find_by! secret: payment_intent['client_secret']
         storage = Storage.find_by user_id: order.user_id
         order.paid = true
         if storage.nil?
            storage = Storage.new
            storage.user_id = order.user_id
            storage.stop_at = Time.now + order.months.months
            storage.storage = order.storage
         else
            if order.action == StorageHistory::ACTION_CHANGE
               storage.storage = order.storage
            end
            storage.stop_at = storage.stop_at + order.months.months
         end
         Storage.transaction do
            order.save!
            storage.save!
         end

      else
         puts "Unhandled event type: #{event.type}"
      end
      succeed
   end
end
