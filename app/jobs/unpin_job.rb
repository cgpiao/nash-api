class UnpinJob < ApplicationJob
   queue_as :default

   def perform(uuid, user)
      attachment = Attachment.find_by uuid: uuid
      url = "#{Rails.configuration.x.ipfs_host}/api/v0/pin/rm?arg=#{attachment.cid}"
      begin
         HTTP.post url
         user_attachment = UserAttachment.find_by user_id: user.id, attachment_id: attachment.id

         UserAttachment.transaction do
            user_attachment.pinned_date = nil
            user_attachment.unpinned_date = Time.now()
            user_attachment.save!
            attachment.ref_count = attachment.ref_count - 1
            attachment.save!
         end

         if attachment.ref_count == 0
            `ipfs repo gc`
         end
      rescue => err
         failed_job = FailedJob.new
         failed_job.name = 'UnpinJob'
         failed_job.arguments = {uuid: uuid}
         failed_job.reason = err.message
         failed_job.save!
      end
   end
end
