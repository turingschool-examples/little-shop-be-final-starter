class Api::V1::Merchants::InvoicesController < ApplicationController
  def index
    merchant = Merchant.find(params[:merchant_id])
    if params[:status].present?
      invoices = merchant.invoices_filtered_by_status(params[:status])
    else
      invoices = merchant.invoices
    end
    render json: InvoiceSerializer.new(invoices)
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    invoice = merchant.invoices.find(params[:id])
    invoice.update(invoice_params)
    render json: InvoiceSerializer.new(invoice), status: :ok
  end

  private

  def invoice_params
    params.require(:invoice).permit(:coupon_id, :status)
  end
end