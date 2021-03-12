class CreateAttachments < ActiveRecord::Migration[6.1]
   def change
      enable_extension 'hstore' unless extension_enabled?('hstore')
      create_table :attachments do |t|
         t.uuid :uuid
         t.string :mime
         t.string :cid
         t.bigint :file_size
         t.bigint :disk_size
         t.boolean :is_directory
         t.integer :ref_count, default: 0
         t.timestamps
      end
   end
end
