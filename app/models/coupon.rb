class Coupon < ApplicationRecord
  belongs_to :merchant, required: true
  has_many :invoices

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :discount_value, presence: true
  validates :discount_type, inclusion: { in: ["percent", "dollar"] }
  validate :merchant_cannot_exceed_five_active_coupons, if: :active?

  def self.by_merchant(merchant_id)
    where(merchant_id: merchant_id)
  end

  def self.find_by_merchant_and_id(merchant_id, coupon_id)
    find_by(merchant_id: merchant_id, id: coupon_id)
  end

  def self.create_for_merchant(merchant_id, params)
    merchant = Merchant.find_by(id: merchant_id)
    return nil unless merchant
    merchant.coupons.create(params)
  end

  def usage_count
    invoices.count
  end

  def update_with_status(params)
    update(params)
  end

  private

  def merchant_cannot_exceed_five_active_coupons
    return unless merchant.present?

    if merchant.coupons.where(active: true).count >= 5
      errors.add(:base, 'Merchant cannot have more than 5 active coupons')
    end
  end
end
