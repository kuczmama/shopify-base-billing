ShopifyApp.configure do |config|
  config.application_name = 'Default App With Billing'
  config.api_key = ENV["SHOPIFY_APP_API_KEY"]
  config.secret = ENV["SHOPIFY_APP_API_SECRET"]
  config.scope = "read_orders,read_products"
  config.embedded_app = true
end
