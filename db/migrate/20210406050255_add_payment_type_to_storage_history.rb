class AddPaymentTypeToStorageHistory < ActiveRecord::Migration[6.1]
  def change
    add_column :storage_histories, :payment_type, :string, default: 'card'
  end
end
