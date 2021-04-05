class AddNoteToTemp < ActiveRecord::Migration[6.1]
   def change
      add_column :temps, :note, :text
   end
end
