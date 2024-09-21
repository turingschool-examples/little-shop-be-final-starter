class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  validates :name, presence: true
  validates :code, presence: true

  def self.for_merchant(merchant_id)
    where(merchant_id: merchant_id)
  end

  def activate_coupon
    if merchant.coupons.where(active: true).count < 5
      update(active: true)
    else
      false
    end
  end
end