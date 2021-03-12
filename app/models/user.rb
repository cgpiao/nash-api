class User < ApplicationRecord
   has_secure_password
   has_many :attachments, -> {select(:uuid, :original_name, :mime, :file_size, :disk_size,
                                     :is_directory, :meta, :cid, :created_at, :pinned_date, :unpinned_date,
                                     'extract(epoch from pinned_date) as pinned_seconds')}
   has_many :user_tokens
   validates :username, presence: true, length: { minimum: 5 }, on: :create
   validates :password, length: { in: 8..20 }, on: :create
   before_create :init_model

   def init_model
      unless self.roles
         self.roles = 'ROLE_USER'
      end
   end
end
