Rails.application.routes.draw do
  mount ShopifyApp::Engine, at: '/'
  controller :sessions do
    get 'login' => :new, :as => :login
    post 'login' => :create, :as => :authenticate
    get 'auth/shopify/callback' => :callback
    get 'logout' => :destroy, :as => :logout
  end

  root :to => 'home#index'
end
