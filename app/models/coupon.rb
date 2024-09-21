class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  def self.for_merchant(merchant_id)
    where(merchant_id: merchant_id)
  end
end