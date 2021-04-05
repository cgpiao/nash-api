class CreateUserAttachment < ActiveRecord::Migration[6.1]
   def change
      create_table :user_attachment do |t|
         t.references :user, null: false, foreign_key: false
         t.references :attachment, null: false, foreign_key: false
         t.string :original_name
         t.hstore :meta
         t.datetime :pinned_date
         t.datetime :unpinned_date
         t.datetime :added_date
         t.timestamps
      end
   end
end
