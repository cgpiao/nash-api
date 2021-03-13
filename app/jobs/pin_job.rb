class PinJob < ApplicationJob
   queue_as :default

   def perform(cid, user_id, custom_name, uuid)
      temp_folder = Rails.configuration.x.temp_folder
      output = temp_folder + '/' + uuid
      begin
         url = "#{Rails.configuration.x.gateway}/#{cid}"
         response = HTTP.get url
         File.open(output,'wb') do |f|
            f.write response.body
         end

         # AddFileJob.perform_now params[:custom_name], @root_file, @user.id, uuid, @original_filename
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
