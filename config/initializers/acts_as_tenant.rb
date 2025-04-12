ActsAsTenant.configure do |config|
  config.require_tenant = lambda do
    Current.user.present?
  end
end
