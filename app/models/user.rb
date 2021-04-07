class User < ApplicationRecord
   STORAGE_FREE_TIER = 1
   has_secure_password
   has_many :attachments, -> {select(:uuid, :original_name, :mime, :file_size, :disk_size,
                                     :is_directory, :meta, :cid, :created_at, :pinned_date, :unpinned_date,
                                     'extract(epoch from pinned_date) as pinned_seconds')}
   has_many :user_tokens
   has_many :storage_histories, -> {
      where("paid=?", true)
         .select(:months, :storage)
         .order(created_at: :desc)
   }
   has_one :storage, -> {
      select(:storage, :stop_at,
             'extract(epoch from storages.created_at) as created_seconds',
             'extract(epoch from storages.stop_at) as stop_seconds')
         .order(created_at: :desc)
   }
   validates :username, presence: true, length: { minimum: 5 }, on: :create
   validates :password, length: { in: 8..20 }, on: :create
   before_create :init_model

   attr_accessor :order
   def init_model
      unless self.roles
         self.roles = 'ROLE_USER'
      end
   end

   def available_storage
      self.storage ? self.storage.storage + User::STORAGE_FREE_TIER : User::STORAGE_FREE_TIER
   end

   def remain_storage
      user_amount = self.storage ? self.storage.storage + User::STORAGE_FREE_TIER : User::STORAGE_FREE_TIER
      user_amount * 1024 * 1024 * 1024 - self.file_amount
   end
end
