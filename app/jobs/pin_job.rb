class PinJob < ApplicationJob
   queue_as :default

   def perform(cid, user_id, custom_name, uuid)
      temp_folder = Rails.configuration.x.temp_folder
      output = temp_folder + '/' + uuid
      begin
         url = "#{Rails.configuration.x.gateway}/#{cid}"
         puts url
         response = HTTP.get url
         File.open(output,'wb') { |f| f.write response.body }
         f = File.open output
         AddFileJob.perform_now custom_name, uuid, user_id, uuid, nil
      rescue => err
         failed_job = FailedJob.new
         failed_job.name = 'PinJob'
         failed_job.arguments = {cid: cid, user_id: user_id}
         failed_job.reason = err.message
         failed_job.save!
      end
   end
end
