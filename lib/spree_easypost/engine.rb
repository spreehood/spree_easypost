module SpreeEasypost
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_easypost'

    config.autoload_paths += %W[#{config.root}/lib]

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer "spree_easypost.environment", before: :load_config_initializers do |_app|
      require 'spree/core/preferences/store'
      SpreeEasypost::Config = SpreeEasypost::Configuration.new
    end

    config.after_initialize do
      begin
        if defined?(Spree::Core::Engine) && ActiveRecord::Base.connection.table_exists?('spree_preferences')
          SpreeEasypost::Config.load_preferences
          Rails.logger.info "SpreeEasypost preferences loaded successfully"
        end
      rescue StandardError => e
        Rails.logger.error "Failed to load SpreeEasypost preferences: #{e.message}"
      end
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
