class Storage < ApplicationRecord
   before_create :init_model
   belongs_to :user

   def init_model
      self.uuid = SecureRandom.uuid
   end
end
