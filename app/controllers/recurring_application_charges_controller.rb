class RecurringApplicationChargesController < AuthenticatedController
  # Note this controller isn't really used for anything except callbacks
  before_action :load_current_recurring_charge

  def show
  end

  def customize
    @recurring_application_charge.customize(params[:recurring_application_charge])
    fullpage_redirect_to @recurring_application_charge.update_capped_amount_url
  end

  def callback
    @recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.find(params[:charge_id])
    if @recurring_application_charge.status == 'accepted'
      @recurring_application_charge.activate
    end

    redirect_to root_path
  end

  def destroy
    @recurring_application_charge.cancel

    flash[:success] = "Recurring application charge was cancelled successfully"

    redirect_to root_path
  end

  def load_current_recurring_charge
    @recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.current
  end
end
