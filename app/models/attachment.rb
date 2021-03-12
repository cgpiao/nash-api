class Attachment < ApplicationRecord
   before_create :init_model

   def init_model
      self.uuid = SecureRandom.uuid
   end
end
