class CreateFailedJobs < ActiveRecord::Migration[6.1]
   def change
      create_table :failed_jobs do |t|
         t.string :name
         t.json :arguments
         t.text :reason
         t.timestamps
      end
   end
end
