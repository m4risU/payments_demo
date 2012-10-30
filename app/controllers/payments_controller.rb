class PaymentsController < ApplicationController
  def index
    @payments = Payment.all

    @late_payment_events = PaymentEvent.not_paid.late.sorted
    @current_month_payments = PaymentEvent.current_month.sorted

    @payments_pending = PaymentEvent.current_month.not_paid.joins(:payment).sum(:amount)
    @payments_amount = PaymentEvent.current_month.joins(:payment).sum(:amount)
  end

  def show
    @payment = Payment.find(params[:id])
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(params[:payment])
    if @payment.save
      redirect_to @payment, :notice => "Successfully created payment."
    else
      render :action => 'new'
    end
  end

  def edit
    @payment = Payment.find(params[:id])
  end

  def update
    @payment = Payment.find(params[:id])
    if @payment.update_attributes(params[:payment])
      redirect_to @payment, :notice  => "Successfully updated payment."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy
    redirect_to payments_url, :notice => "Successfully destroyed payment."
  end
end