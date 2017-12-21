class HomeController < ShopifyApp::AuthenticatedController
  def index
    unless ShopifyAPI::RecurringApplicationCharge.current
      # Create it
      redirect_to recurring_application_charge_path
    end
    # render home
  end
end
