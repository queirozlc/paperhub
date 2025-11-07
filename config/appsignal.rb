Appsignal.configure do |config|
  config.activate_if_environment(:development, :production)
  config.name = "Paperhub"
  config.push_api_key = ENV["APPSIGNAL_PUSH_API_KEY"]
end
