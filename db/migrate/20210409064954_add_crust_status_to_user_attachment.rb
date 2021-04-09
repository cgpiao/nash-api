class AddCrustStatusToUserAttachment < ActiveRecord::Migration[6.1]
   def change
      add_column :user_attachment, :crust_status, :integer, default: 0
   end
end
