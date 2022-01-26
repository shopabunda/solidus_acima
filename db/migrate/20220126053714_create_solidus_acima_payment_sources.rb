class CreateSolidusAcimaPaymentSources < ActiveRecord::Migration[6.1]
  def change
    create_table :solidus_acima_payment_sources do |t|
      t.string :merchant_id
      t.string :iframe_url
      t.integer :payment_method_id, index: true
      t.timestamps
    end

    add_foreign_key :solidus_acima_payment_sources, :spree_payment_methods, column: :payment_method_id
  end
end
