class RecurringApplicationChargesController < AuthenticatedController
  before_action :load_current_recurring_charge

  def show
  end

  def create
    @recurring_application_charge.try!(:cancel)

    recurring_charge = {}
    recurring_charge[:recurring_charge_name] = Rails.application.secrets.recurring_charge_name
    recurring_charge[:recurring_charge_price] = Rails.application.secrets.recurring_charge_price
    recurring_charge[:recurring_charge_capped_amount] = Rails.application.secrets.recurring_charge_capped_amount
    recurring_charge[:recurring_charge_terms] = Rails.application.secrets.recurring_charge_terms
    recurring_charge[:recurring_charge_trial_days] = Rails.application.secrets.recurring_charge_trial_days

    @recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.new({recurring_application_charge: recurring_charge})
    @recurring_application_charge.test = true
    @recurring_application_charge.return_url = callback_recurring_application_charge_url

    if @recurring_application_charge.save
      # fullpage_redirect_to is a shopify_app thing and it breaks without the
      #   include ShopifyApp::EmbeddedApp in Authenticated Controller
      # https://github.com/Shopify/shopify_app/issues/387
      # http://www.rubydoc.info/gems/shopify_app/6.4.2/ShopifyApp%2FController%3Afullpage_redirect_to
      fullpage_redirect_to @recurring_application_charge.confirmation_url
    else
      flash[:danger] = @recurring_application_charge.errors.full_messages.first.to_s.capitalize
      redirect_to_correct_path(@recurring_application_charge)
    end
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

    redirect_to_correct_path(@recurring_application_charge)
  end

  def destroy
    @recurring_application_charge.cancel

    flash[:success] = "Recurring application charge was cancelled successfully"

    redirect_to_correct_path(@recurring_application_charge)
  end

  private

  def load_current_recurring_charge
    @recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.current
  end

  def recurring_application_charge_params
    params.require(:recurring_application_charge).permit(
      :name,
      :price,
      :capped_amount,
      :terms,
      :trial_days
    )
  end

  def redirect_to_correct_path(recurring_application_charge)
    if recurring_application_charge.try(:capped_amount)
      redirect_to usage_charge_path
    else
      redirect_to recurring_application_charge_path
    end
  end
end
