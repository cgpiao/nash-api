class AddNoteToStorageHistory < ActiveRecord::Migration[6.1]
   def change
      add_column :storage_histories, :note, :text
   end
end
