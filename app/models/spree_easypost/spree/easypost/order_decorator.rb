module SpreeEasypost
  module Spree
    module Easypost
      module OrderDecorator
        def easypost_rate_total
          shipments.sum { |shipment| shipment.shipping_rates.sum { |rate| rate.easy_post_rate.to_f } }        
        end
      end
    end
  end
end

Spree::Order.prepend(SpreeEasypost::Spree::Easypost::OrderDecorator)
