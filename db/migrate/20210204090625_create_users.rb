class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.text :roles
      t.string :password_digest
      t.bigint :file_amount
      t.bigint :disk_amount

      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end
