class MessageSendJob < ApplicationJob
   queue_as :default

   def perform(*args)
      phone, code = args
      Rails.configuration.x.twilio => {sid: }
   end
end
