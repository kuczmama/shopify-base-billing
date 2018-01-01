class HomeController < ShopifyApp::AuthenticatedController
  def index
    unless ShopifyAPI::RecurringApplicationCharge.current
      # Create it
      #redirect_to recurring_application_charge_path
      recurring_application_charge = RecurringApplicationChargesService.create

      if recurring_application_charge.save
        # fullpage_redirect_to is a shopify_app thing and it breaks without the
        #   include ShopifyApp::EmbeddedApp in Authenticated Controller
        # https://github.com/Shopify/shopify_app/issues/387
        # http://www.rubydoc.info/gems/shopify_app/6.4.2/ShopifyApp%2FController%3Afullpage_redirect_to

        fullpage_redirect_to recurring_application_charge.confirmation_url
      else
        flash[:danger] = recurring_application_charge.errors.full_messages.first.to_s.capitalize
        redirect_to recurring_application_charge_path
      end
      return
    end
    add_script_tag
    render 'index'
  end

  def add_script_tag
    script_tag = ShopifyAPI::ScriptTag.new
    script_tag.event = "onload"
    script_tag.src = "https://www.mkucz.com/assets/js/shopify/sticky-button.js?shop=#{ShopifyAPI::Shop.current.domain}"
    script_tag.save
  end
end
