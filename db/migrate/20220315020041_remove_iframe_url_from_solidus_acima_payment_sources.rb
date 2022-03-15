class RemoveIframeUrlFromSolidusAcimaPaymentSources < ActiveRecord::Migration[6.1]
  def change
    remove_column :solidus_acima_payment_sources, :iframe_url, :string
  end
end
