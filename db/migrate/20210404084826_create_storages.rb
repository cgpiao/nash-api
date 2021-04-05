class CreateStorages < ActiveRecord::Migration[6.1]
   def change
      create_table :storages do |t|
         t.uuid :uuid
         t.references :user, null: false, foreign_key: false
         t.integer :storage
         t.datetime :stop_at
         t.timestamps
      end
   end
end
