class MessageSendJob < ApplicationJob
   queue_as :default

   def perform(*args)
      phone, code = args
      puts 'perform1 ' + phone
      Rails.configuration.x.twilio => {sid: }
   end
end
