# Shopify Base Billing

This is a starter app with recurring base billing setup.  This app will get you quickly started with a working shopify application.

# Setup
## 1. Create an account
 Create an account at https://partners.shopify.com/.

## 2. Create an app

In the shopify partners dashboard click **Apps -> Create App**
<img src='./public/images/readme/create-app-button.png' />

#### Enter in your app information
- **App Name**: [Your App Name]
- **App Url**: https://[ngrok path].ngrok.io
<img src='./public/images/readme/create-app-popup.png' />

#### Add Redirect URL
In shopify make sure to add the NGROK redirect URL.
`https://[your ngrok string].ngrok.io/auth/shopify/callback`
<img src='./public/images/readme/redirect-urls.png' />


#### GET API Keys
On the same page that you set the redirect URLs, you can find the app credentials.  You will get the `API Key` and the `API Secret Key`. We will use these  when we set the environenment variables in the next step.

<img src='./public/images/readme/api-keys.png' />


### NGROK

#### Install NGROK
Install NGROK at https://ngrok.com/download.

#### Run NGROK

<pre>
[/path/to_ngrok]</path>/ngrok http 3000
</pre>

# Installation

## 1. Configure Environment Variables
Set the environment variables that you got in the previous set for `SHOPIFY_APP_API_KEY` and `SHOPIFY_APP_API_SECRET`. 

You should be able to get them from 
Apps --> [Your App Name] --> App Info

<pre>
ShopifyApp.configure do |config|
  config.application_name = 'Default App With Billing'
  config.api_key = ENV["SHOPIFY_APP_API_KEY"]
  config.secret = ENV["SHOPIFY_APP_API_SECRET"]
  config.scope = "read_orders, read_products"
  config.embedded_app = true
end

</pre>

## 2. Run Migrations
<pre>
rails db:create db:migrate
</pre>


# Important Gems Used
## Shopify App
This gem includes a Rails Engine and generators for writing Rails applications using the Shopify API. The Engine provides a SessionsController and all the required code for authenticating with a shop via Oauth (other authentication methods are not supported).
- Github: https://github.com/Shopify/shopify_app
- Documentation: http://www.rubydoc.info/gems/shopify_app/8.2.5

## Shopify API
The Shopify API gem allows Ruby developers to programmatically access the admin section of Shopify stores.

The API is implemented as JSON over HTTP using all four verbs (GET/POST/PUT/DELETE). Each resource, like Order, Product, or Collection, has its own URL and is manipulated in isolation. In other words, we’ve tried to make the API follow the REST principles as much as possible.

- Github: https://github.com/Shopify/shopify_api

## omniauth-shopify-oauth2
Shopify OAuth2 Strategy for OmniAuth 1.0.

- Github: https://github.com/Shopify/omniauth-shopify-oauth2