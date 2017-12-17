class Shop < ApplicationRecord
  validates :shopify_domain, presence: true, uniqueness: true
  validates :shopify_token, presence: true

  def with_shopify_session(&block)
    ShopifyAPI::Session.temp(shopify_domain, shopify_token, &block)
  end

  def self.store(session)
    shop = self.find_or_initialize_by(shopify_domain: session.url)
    shop.shopify_token = session.token
    shop.save!
    shop.id
  end

  def self.retrieve(id)
    return unless id

    if shop = self.find_by(id: id)
      ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token)
    end
  end
end
