class AddFileJob < ApplicationJob
   queue_as :default

   def perform(custom_name, root_file, user_id, uuid, original_name)
      temp_folder = Rails.configuration.x.temp_folder
      source_file = "#{temp_folder}/#{root_file}"
      begin
         if File.directory? source_file
            @response = `ipfs add -r #{source_file.gsub(/ /, "\ ")}`
         else
            @response = `ipfs add #{source_file.gsub(/ /, "\ ")}`
         end

         @response.split("\n").each do |r|
            columns = r.split ' '
            if root_file == columns[2]
               attachment = Attachment.find_by cid: columns[1]
               if attachment.nil?
                  attachment = Attachment.new
               end
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
                  user = User.find user_id
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
                  user = Temp.find_by(key: uuid)
                  user.update!(value: Temp::PINNED)
               end
            end
         end
         FileUtils.rm_r source_file
         # if File.directory? source_file
         #    response = `ipfs add -r #{source_file.gsub(/ /, "\ ")}`
         #    base_name = File.basename(source_file)
         #    response.split("\n").each do |r|
         #       columns = r.split ' '
         #       if base_name == columns[2]
         #          attachment.cid = columns[1]
         #          attachment.file_size = Dir[source_file + '/**/*'].select { |f| File.file?(f) }.sum { |f| File.size(f) }
         #          attachment.disk_size = Dir[source_file + '/**/*'].select { |f| File.file?(f) }.sum { |f| File.stat(f).blocks * 512 }
         #          attachment.added_date = Time.now
         #          attachment.pinned_date = Time.now
         #          Attachment.transaction do
         #             user = User.find attachment.user_id
         #             attachment.save!
         #             user.file_amount = 0 if user.file_amount.nil?
         #             user.disk_amount = 0 if user.disk_amount.nil?
         #             user.file_amount = user.file_amount + attachment.file_size
         #             user.disk_amount = user.disk_amount + attachment.disk_size
         #             user.save!
         #          end
         #       end
         #    end
         #    FileUtils.rm_r source_file
         # else
         #    response = `ipfs add #{source_file.gsub(/ /, "\ ")}`
         #    base_name = File.basename(source_file)
         #    response.split("\n").each do |r|
         #       columns = r.split ' '
         #       if base_name == columns[2]
         #          attachment.cid = columns[1]
         #          attachment.file_size = File.size(source_file)
         #          attachment.disk_size = File.stat(source_file).blocks * 512
         #          attachment.added_date = Time.now
         #          attachment.pinned_date = Time.now
         #          Attachment.transaction do
         #             user = User.find attachment.user_id
         #             attachment.save!
         #             user.file_amount = 0 if user.file_amount.nil?
         #             user.disk_amount = 0 if user.disk_amount.nil?
         #             user.file_amount = user.file_amount + attachment.file_size
         #             user.disk_amount = user.disk_amount + attachment.disk_size
         #             user.save!
         #          end
         #       end
         #    end
         #    # FileUtils.rm_r source_file
         # end
      #
      # rescue => err
      #    failed_job = FailedJob.new
      #    failed_job.name = 'AddFileJob'
      #    # custom_name, root_file, user, uuid
      #    failed_job.arguments = {custom_name: custom_name, root_file: root_file, user_id: user_id, uuid: uuid}
      #    failed_job.reason = err.message
      #    failed_job.save!
      end
   end
end
