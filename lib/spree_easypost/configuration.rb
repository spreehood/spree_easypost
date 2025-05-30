module SpreeEasypost
  class Configuration < Spree::Preferences::Configuration
    preference :enabled, :boolean, default: true
    preference :buy_postage_when_shipped, :boolean, default: false
    preference :validate_address_with_easypost, :boolean, default: false
    preference :use_easypost_on_frontend, :boolean, default: false
    preference :customs_signer, :string, default: ''
    preference :customs_contents_type, :string, default: 'merchandise'
    preference :customs_eel_pfc, :string, default: 'NOEEI 30.37(a)'
    preference :carrier_accounts_shipping, :string, default: ''
    preference :carrier_accounts_returns, :string, default: ''
    preference :endorsement_type, :string, default: 'RETURN_SERVICE_REQUESTED'
    preference :returns_stock_location_id, :integer, default: 0
    preference :api_key, :string

    def load_preferences
      stored_prefs = Spree::Preference.where("key LIKE 'spree_easypost/config/%'")

      stored_prefs.each do |pref|
        preference_name = pref.key.gsub('spree_easypost/config/', '')
        
        # Cast the value based on preference type
        value = case self.preference_type(preference_name)
        when :boolean
          [true, "true", "1", 1].include?(pref.value)
        when :integer
          pref.value.to_i
        else
          pref.value
        end

        self[preference_name] = value if self.has_preference?(preference_name)
      end
    end
  end
end
