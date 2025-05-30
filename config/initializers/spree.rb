Rails.application.config.after_initialize do
  Rails.application.config.spree_admin.store_nav_partials << 'spree/admin/shared/easypost_nav'
end
