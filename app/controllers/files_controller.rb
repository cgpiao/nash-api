class FilesController < ApplicationController

   def index
      query = UserAttachment.joins('JOIN attachments on user_attachment.attachment_id = attachments.id')
                            .where('user_attachment.user_id = ?', @user.id)
      if params[:name]
         query = query.where('user_attachment.original_name like ?', "%#{params[:name]}%")
      end
      if params[:status] == 'Pinned'
         query = query.where('user_attachment.pinned_date is not null')
      elsif params[:status] == 'Unpinned'
         query = query.where('user_attachment.pinned_date is null')
      end
      if params[:start_date]
         query = query.where("user_attachment.pinned_date at time zone 'utc' at time zone '#{@timezone}' >= ?", params[:start_date]+' 00:00:00')
      end
      if params[:end_date]
         query = query.where("user_attachment.pinned_date at time zone 'utc' at time zone '#{@timezone}' <= ?", params[:end_date]+' 23:59:59')
      end
      if params[:unpin_start_date]
         query = query.where("user_attachment.unpinned_date at time zone 'utc' at time zone '#{@timezone}' >= ?", params[:unpin_start_date]+' 00:00:00')
      end
      if params[:unpin_end_date]
         query = query.where("user_attachment.unpinned_date at time zone 'utc' at time zone '#{@timezone}' <= ?", params[:unpin_end_date]+' 23:59:59')
      end
      select = %{
         user_attachment.*, attachments.cid as cid, attachments.file_size as file_size, attachments.uuid as uuid
      }
      query = query.select(select)
      succeed query
   end

   def create
      temp_folder = Rails.configuration.x.temp_folder

      params.each_pair do |k, f|
         if k =~ /^file_.*/
            path = Base64.decode64 k[5, k.length]
            if path.index('/').nil?
               @original_filename = f.original_filename
            else
               @original_filename = path[0, path.index('/')]
            end

            target = temp_folder + '/' + SecureRandom.uuid
            if path.index('/').nil?
               File.rename f.path, target
            else
               target_path = target + '/' + path
               folder_name = File.dirname target_path
               folders = []
               until Dir.exists? folder_name
                  folders << folder_name
                  folder_name = File.dirname folder_name
               end
               folders.reverse.each { |f| Dir.mkdir f }

               File.rename f.path, target + '/' + path
            end

            Regexp.new(temp_folder + '/([^/]*).*').match target
            @root_file = Regexp.last_match[1]
         end
      end
      root_absolute_path = "#{temp_folder}/#{@root_file}"
      if File.directory? root_absolute_path
         @file_size = Dir[root_absolute_path + '/**/*'].select { |f| File.file?(f) }.sum { |f| File.size(f) }
      else
         @file_size = File.size(root_absolute_path)
      end
      if @user.remain_storage < @file_size
         fail 1, message: (I18n.t 'msg_3_1')
         return
      end
      uuid = SecureRandom.uuid
      Temp.create! key: uuid, value: Temp::PINNING
      AddFileJob.perform_now params[:custom_name], @root_file, @user.id, uuid, @original_filename
      succeed uuid
   end

   def show
      succeed Temp.find_by key: params[:id]
   end

   def unpin
      UnpinJob.perform_now params[:id], @user
      succeed
   end

end
