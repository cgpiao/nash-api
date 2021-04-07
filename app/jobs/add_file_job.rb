class AddFileJob < ApplicationJob
   queue_as :default

   def perform(custom_name, root_file, user_id, uuid, original_name)
      temp_folder = Rails.configuration.x.temp_folder
      source_file = "#{temp_folder}/#{root_file}"
      user = User.find user_id
      begin
         if File.directory? source_file
            @response = `ipfs add -r #{source_file.gsub(/ /, "\ ")}`
         else
            @response = `ipfs add #{source_file.gsub(/ /, "\ ")}`
         end
         result1 = `crust-cli pin #{source_file.gsub(/ /, "\ ")}`
         logger.info("==== result1: #{result1}")
         @response.split("\n").each do |r|
            columns = r.split ' '
            if root_file == columns[2]
               attachment = Attachment.find_by cid: columns[1]
               if attachment.nil?
                  attachment = Attachment.new
               end
               result2 = `cd /root && crust-cli publish #{columns[1]}`
               logger.info("==== result2: #{result2}")
               attachment.cid = columns[1]
               attachment.mime = `file --b --mime-type '#{source_file}'`.strip
               if File.directory? source_file
                  attachment.is_directory = true
                  attachment.file_size = Dir[source_file + '/**/*'].select { |f| File.file?(f) }.sum { |f| File.size(f) }
                  attachment.disk_size = Dir[source_file + '/**/*'].select { |f| File.file?(f) }.sum { |f| File.stat(f).blocks * 512 }
               else
                  attachment.is_directory = false
                  attachment.file_size = File.size(source_file)
                  attachment.disk_size = File.stat(source_file).blocks * 512
               end

               Attachment.transaction do

                  attachment.save!
                  user_attachment = UserAttachment.find_by user_id: user_id, attachment_id: attachment.id
                  if user_attachment.nil?
                     attachment.ref_count = attachment.ref_count + 1
                     attachment.save!
                     user_attachment = UserAttachment.new
                     user_attachment.user_id = user_id
                     user_attachment.attachment_id = attachment.id
                     user.file_amount = 0 if user.file_amount.nil?
                     user.disk_amount = 0 if user.disk_amount.nil?
                     user.file_amount = user.file_amount + attachment.file_size
                     user.disk_amount = user.disk_amount + attachment.disk_size

                     user.save!

                  end
                  user_attachment.original_name = original_name
                  user_attachment.added_date = Time.now
                  user_attachment.pinned_date = Time.now
                  user_attachment.meta = {
                     custom_name: custom_name
                  }
                  user_attachment.save!
                  temp = Temp.find_by(key: uuid)
                  temp.update!(value: Temp::PINNED)
               end
            end
         end
         FileUtils.rm_r source_file
      rescue => err
         failed_job = FailedJob.new
         failed_job.name = 'AddFileJob'
         failed_job.arguments = { custom_name: custom_name, root_file: root_file, user_id: user_id, uuid: uuid }
         failed_job.reason = err.message
         failed_job.save!
      end
   end
end
