class CreateUserTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :user_tokens do |t|
      t.references :user, null: false, foreign_key: false
      t.string :auth_token
      t.datetime :expired_at
    end
    add_index :user_tokens, :auth_token, unique: true
  end
end
