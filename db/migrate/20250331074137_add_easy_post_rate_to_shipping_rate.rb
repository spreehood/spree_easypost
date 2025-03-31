class AddEasyPostRateToShippingRate < ActiveRecord::Migration[7.1]
  def change
    add_column :spree_shipping_rates, :easy_post_rate, :float, default: 0.0
  end
end
