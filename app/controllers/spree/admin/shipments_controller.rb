module Spree
  module Admin
    class ShipmentsController < Spree::Admin::BaseController
      def buy_postage
        begin
          params[:shipment] ||= {}

          unless resource.tracking_label?
            resource.buy_easypost_rate
            resource.save!

            unless resource.shipped?
              resource.ship!
            end
          end

          redirect_to edit_admin_order_path(resource.order)
        rescue ::EasyPost::Errors => e
          flash[:error] = "EasyPost Error: #{e.message}"
        rescue StandardError => e
          flash[:error] = "An error occurred: #{e.message}"
        end
      end

      private

      def resource
        @resource ||= Spree::Shipment.find_by(number: params[:id])
      end
    end
  end
end
