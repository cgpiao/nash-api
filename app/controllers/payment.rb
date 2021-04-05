module Payment
   YOUR_DOMAIN = 'http://localhost:3000'

   class SessionsController < ApplicationController
      def create
         session = Stripe::Checkout::Session.create(
            {
               payment_method_types: ['card'],
               line_items: [
                  {
                     price_data: {
                        unit_amount: 2000,
                        currency: 'usd',
                        product_data: {
                           name: 'Stubborn Attachments',
                           images: ['https://i.imgur.com/EHyR2nP.png'],
                        },
                     },
                     quantity: 1,
                  }
               ],
               mode: 'payment',
               success_url: YOUR_DOMAIN + '/success',
               cancel_url: YOUR_DOMAIN + '/cancel',
            })
         {
            id: session.id
         }.to_json
      end
   end
end
