class AddClientSecretsToSolidusAcimaPaymentSources < ActiveRecord::Migration[6.1]
  def change
    add_column :solidus_acima_payment_sources, :client_id, :string
    add_column :solidus_acima_payment_sources, :client_secret, :string
  end
end
