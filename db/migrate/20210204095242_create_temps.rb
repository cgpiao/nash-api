class CreateTemps < ActiveRecord::Migration[6.1]
  def change
    create_table :temps do |t|
      t.string :key
      t.text :value

      t.timestamps
    end
    add_index :temps, :key, unique: true
  end
end
