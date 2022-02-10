class AddColumnsToSolidusAcimaPaymentSources < ActiveRecord::Migration[6.1]
  def change
    add_column :solidus_acima_payment_sources, :api_key, :string
    add_column :solidus_acima_payment_sources, :lease_id, :string
    add_column :solidus_acima_payment_sources, :lease_number, :string
    add_column :solidus_acima_payment_sources, :checkout_token, :string
  end
end
