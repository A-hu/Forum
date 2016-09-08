# PROFILE permission required!!
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :line, "Channel_ID", "Channel_Secret"
end