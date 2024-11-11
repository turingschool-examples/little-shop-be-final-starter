class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  belongs_to :coupon, optional: true
  has_many :invoice_items, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :status, inclusion: { in: ["shipped", "packaged", "returned"] }

  def total_amount
    invoice_items
    .joins(:item)
    .where(items: { merchant_id: merchant_id})
    .sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def total_after_discount
    return total_amount unless coupon

    case coupon.discount_type
    when 'percent_off'
      discounted_total = total_amount * (1 - (coupon.discount_value / 100.0))
    when 'dollar_off'
      discounted_total = total_amount - coupon.discount_value
    else
      discounted_total = total_amount
    end
    [discounted_total, 0].max
  end
end