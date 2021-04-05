class ResetUserUsageJob < ApplicationJob
   queue_as :default

   def perform(*args)
      users = User.all
      users.each do |user|
         ua_list = UserAttachment.where(user_id: user.id)
         attachment_ids = ua_list.map {_1.attachment_id}
         attachments = Attachment.where(id: attachment_ids)
         total_file_size = attachments.sum { _1.file_size}
         total_disk_size = attachments.sum { _1.disk_size}
         user.file_amount = total_file_size
         user.disk_amount = total_disk_size
         user.save!
      end
   end
end
