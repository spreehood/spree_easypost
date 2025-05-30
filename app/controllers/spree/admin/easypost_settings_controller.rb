module Spree
  module Admin
    class EasypostSettingsController < Spree::Admin::BaseController
      before_action :load_stock_locations, only: [:edit, :update]

      def edit
      end

      def update
        easypost_settings_params.each do |name, value|
          boolean_prefs = [:enabled, :buy_postage_when_shipped, :validate_address_with_easypost, :use_easypost_on_frontend]
          integer_prefs = [:returns_stock_location_id]

          value = if boolean_prefs.include?(name.to_sym)
            ActiveModel::Type::Boolean.new.cast(value)
          elsif integer_prefs.include?(name.to_sym)
            value.to_i
          else
            value
          end

          # Save to preference store with Spree-standard key format
          preference_key = "spree_easypost/config/#{name}"
          Spree::Preference.where(key: preference_key).destroy_all
          Spree::Preference.create(key: preference_key, value: value)

          # Update runtime config
          SpreeEasypost::Config[name] = value if SpreeEasypost::Config.respond_to?("#{name}=")
        end

        flash[:success] = Spree.t(:easypost_settings_updated)
        redirect_to edit_admin_easypost_setting_path
      end
      private

      def load_stock_locations
        @stock_locations = Spree::StockLocation.all
      end

      def update_easypost_settings
        easypost_settings_params.each do |key, value|
          SpreeEasypost::Config[key] = value
        end
      end

      def easypost_settings_params
        params.require(:settings).permit(
            :buy_postage_when_shipped,
            :validate_address_with_easypost,
            :use_easypost_on_frontend,
            :customs_signer,
            :customs_contents_type,
            :customs_eel_pfc,
            :carrier_accounts_shipping,
            :carrier_accounts_returns,
            :endorsement_type,
            :returns_stock_location_id,
            :api_key
        )
      end
    end
  end
end
