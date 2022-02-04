class AddApiKeyToSolidusAcimaPaymentSources < ActiveRecord::Migration[6.1]
  def change
    add_column :solidus_acima_payment_sources, :api_key, :string
  end
end
