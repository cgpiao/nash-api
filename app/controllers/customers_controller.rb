class CustomersController < ApplicationController
   def create
      customer = Stripe::Customer.create(
         {
            email: 'piaocg@outlook.com',
            payment_method: 'pm_1FWS6ZClCIKljWvsVCvkdyWg',
            invoice_settings: {
               default_payment_method: 'pm_1FWS6ZClCIKljWvsVCvkdyWg',
            },
         })
   end
end
