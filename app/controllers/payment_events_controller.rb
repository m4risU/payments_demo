class PaymentEventsController < ApplicationController

  def update
    @payment = Payment.find(params[:payment_id])
    @payment_event = @payment.payment_events.find(params[:id])
    if @payment_event.update_attributes(params[:payment_event])
      redirect_to :back
    end
  end

end
