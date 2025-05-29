Rails.application.config.to_prepare do
  Spree::PermittedAttributes.shipment_attributes << :tracking_label unless Spree::PermittedAttributes.shipment_attributes.include?(:tracking_label)
  Spree::PermittedAttributes.stock_location_attributes << :time_zone unless Spree::PermittedAttributes.stock_location_attributes.include?(:time_zone)
  Spree::PermittedAttributes.shipping_category_attributes << :use_easypost unless Spree::PermittedAttributes.shipping_category_attributes.include?(:use_easypost)

  Spree::PermittedAttributes.class_eval do
    mattr_accessor :customer_shipment_attributes
    mattr_accessor :scan_form_attributes
  end

  Spree::PermittedAttributes.customer_shipment_attributes ||= [:tracking, :tracking_label, :weight]
  Spree::PermittedAttributes.scan_form_attributes ||= [:stock_location_id]
end
