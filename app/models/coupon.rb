class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :discount_value, presence: true
  validates :discount_type, inclusion: { in: ["percent", "dollar"]}

  def usage_count
    invoices.count
  end

  def self.find_by_merchant_and_id(merchant_id, coupon_id)
    find_by(merchant_id: merchant_id, id: coupon_id)
  end
end