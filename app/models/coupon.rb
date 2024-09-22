class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  validates :name, presence: true
  validates :code, presence: true
  validates :discount_type, inclusion: { in: ['dollar_off', 'percentage_off'] }
  validates :discount_value, numericality: { greater_than: 0 }


  def self.for_merchant_with_status(merchant_id, status = nil)
    coupons = for_merchant(merchant_id)
    return coupons unless status.present?

    case status
    when 'active'
      coupons.where(active: true)
    when 'inactive'
      coupons.where(active: false)
    else
      coupons
    end
  end

  def activate_coupon
    if merchant.coupons.where(active: true).count < 5
      update(active: true)
    else
      false
    end
  end

  def exceeds_active_coupon_limit?
    merchant.coupons.where(active: true).count >= 5
  end

  def code_already_exists?
    Coupon.exists?(code: code)
  end

  private

  def self.for_merchant(merchant_id)
    where(merchant_id: merchant_id)
  end
end