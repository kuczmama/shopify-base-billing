class RecurringApplicationChargesService < AuthenticatedController
  def self.create
    recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.current
    recurring_application_charge.try!(:cancel)

    recurring_charge = {}
    recurring_charge[:name] = Rails.application.secrets.recurring_charge_name
    recurring_charge[:price] = Rails.application.secrets.recurring_charge_price
    recurring_charge[:terms] = Rails.application.secrets.recurring_charge_terms
    recurring_charge[:trial_days] = Rails.application.secrets.recurring_charge_trial_days

    recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.new({recurring_application_charge: recurring_charge})
    recurring_application_charge.test = Rails.application.secrets.is_test_charge
    recurring_application_charge.return_url = Rails.application.routes.url_helpers.callback_recurring_application_charge_url

    return recurring_application_charge
  end

  private

  def self.recurring_application_charge_params
    params.require(:recurring_application_charge).permit(
      :name,
      :price,
      :terms,
      :trial_days
    )
  end
end
