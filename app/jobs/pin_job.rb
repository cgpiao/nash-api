class PinJob < ApplicationJob
   queue_as :default

   def perform(cid, user_id, custom_name, uuid)
      temp_folder = Rails.configuration.x.temp_folder
      output = temp_folder + '/' + uuid
      @user = User.find user_id
      begin
         url = "#{Rails.configuration.x.gateway}/#{cid}"
         response = HTTP.get url
         File.open(output,'wb') do |f|
            f.write response.body
         end
         if File.directory? output
            @file_size = Dir[output + '/**/*'].select { |f| File.file?(f) }.sum { |f| File.size(f) }
         else
            @file_size = File.size(output)
         end
         p "remain: #{@user.remain_storage}, size: #{@file_size}"
         if @user.remain_storage < @file_size
            temp = Temp.find_by(key: uuid)
            temp.update!(value: Temp::ERROR, note: (I18n.t 'msg_3_1'))
         else
            AddFileJob.perform_now custom_name, uuid, user_id, uuid, nil
         end
         # AddFileJob.perform_now params[:custom_name], @root_file, @user.id, uuid, @original_filename
      rescue => err
         failed_job = FailedJob.new
         failed_job.name = 'PinJob'
         failed_job.arguments = {cid: cid, user_id: user_id}
         failed_job.reason = err.message
         failed_job.save!
      end
   end
end
