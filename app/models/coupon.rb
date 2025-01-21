class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices
  
  validates :full_name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :active, inclusion: { in: [true, false]}
  validates :merchant_id, presence: true 
  validates :usage_count, presence: true
  validate :discount_type_constraints
  validate :merchant_coupon_limit_to_five  
  
  def more_than_five_active_coupons?(merchant)
    merchant.coupons.where(active: true).count >= 5
  end

  private

  def discount_type_constraints
    if !percent_off.present? && !dollar_off.present?
      errors.add(:base, "one discount type (percent or dollar off) must be specified.")
    elsif percent_off.present? && dollar_off.present?
      errors.add(:base, "only one discount type (percent or dollar off) can be specified at a time.")
    end
  end 


  def merchant_coupon_limit_to_five 
    if active? && merchant && merchant.coupons.where(active: true).count >= 5
      errors.add(:base, "This merchant already has 5 active coupons.")
    end
  end
end


