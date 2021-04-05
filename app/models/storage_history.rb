class StorageHistory < ApplicationRecord
   ACTION_ADD = 'A'
   ACTION_CHANGE = 'C'
   before_create :init_model
   belongs_to :user

   def init_model
      self.uuid = SecureRandom.uuid
   end
end
