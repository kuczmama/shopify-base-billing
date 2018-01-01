ShopifyApp.configure do |config|
  config.application_name = 'Sticky Checkout Button'
  config.api_key = ENV["SHOPIFY_STICKY_CHECKOUT_KEY"]
  config.secret = ENV["SHOPIFY_STICKY_CHECKOUT_SECRET"]
  config.scope = "read_orders,read_products,read_script_tags,write_script_tags"
  config.embedded_app = true
end
