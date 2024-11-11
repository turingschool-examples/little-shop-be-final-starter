class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :active, inclusion: { in: [true, false] }
  
  validate :active_coupon_limit, if: -> { active? && errors[:code].empty? }

  def used_count
    invoices.count
  end

  private

  def active_coupon_limit
    
    if merchant.coupons.where(active: true).count >= 5
      errors.add(:base, "Merchant already has 5 active coupons")
    end
  end
end