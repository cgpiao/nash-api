class CreateStorageHistories < ActiveRecord::Migration[6.1]
   def change
      create_table :storage_histories do |t|
         t.uuid :uuid
         t.references :user, null: false, foreign_key: false
         t.string :secret
         t.integer :storage
         t.integer :months
         t.integer :amount
         t.string :currency, default: 'usd'
         t.string :action, default: 'N'
         t.boolean :paid, default: false
         t.timestamps
      end
   end
end
