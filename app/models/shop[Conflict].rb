class Shop < ApplicationRecord
  include ShopifyApp::Shop

  def self.store(session)
    shop = self.new(domain: session.url, token: session.token)
    shop.save!
    shop.id
  end

  def self.retrieve(id)
    shop = Shop.find_by(id: id)
    return unless shop.present?
    ShopifyAPI::Session.new(shop.domain, shop.token)
  end
end
