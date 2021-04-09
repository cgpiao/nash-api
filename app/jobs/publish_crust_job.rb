class PublishCrustJob < ApplicationJob
   queue_as :default

   def perform(user_id, hash, source_file)
      logger.info("==== #{self.class.name} start, #{user_id}, #{hash}, #{source_file}")
      attachment = Attachment.find_by cid: hash
      user_attachment = UserAttachment.find_by user_id: user_id, attachment_id: attachment.id
      user_attachment.crust_status = 1
      %x[crust-cli pin #{source_file.gsub(/ /, "\ ")}]
      result =  %x[cd /Users/piaocg && crust-cli publish #{hash}]
      unless result =~ /Publish\s\w+\ssuccess/
         p result
         return
      end
      user_attachment.save!
      FileUtils.rm_r source_file
      logger.info("==== #{self.class.name} end")
   end
end
