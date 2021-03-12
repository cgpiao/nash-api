class UserToken < ApplicationRecord
   has_secure_token :auth_token, length: 36
   before_create :set_expired_date

   def set_expired_date
      self.expired_at = 1.year.from_now
   end
end
