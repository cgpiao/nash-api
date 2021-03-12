class HashesController < ApplicationController
   def create
      url = "#{Rails.configuration.x.gateway}/#{params[:id]}"
      response = HTTP.get url
      begin
         if response.code == 200
            uuid = SecureRandom.uuid
            Temp.create! key: uuid, value: Temp::PINNING
            PinJob.perform_later params[:id], @user.id, params[:custom_name], uuid
            succeed uuid
         else
            fail
         end
      rescue
         fail
      end
   end

   def delete
      UnpinJob.perform_later params[:id]
      succeed
   end
end
