class Coupon < ApplicationRecord
    belongs_to :merchant
    has_many :invoices  # A coupon may be applied to one invoice (optional)
  
    validates :name, presence: true
    validates :code, presence: true, uniqueness: true
    validates :discount_type, presence: true, inclusion: { in: ["percent_off", "dollar_off"] }
    validates :discount_amount, presence: true, numericality: { greater_than: 0 }
    validates :status, inclusion: { in: ["active", "inactive"] }
  
    validate :merchant_cannot_have_more_than_five_active_coupons
    before_destroy :prevent_deletion
  
    private
  
    def merchant_cannot_have_more_than_five_active_coupons
      if status == "active" && merchant.coupons.where(status: "active").count >= 5
        errors.add(:merchant, "can only have up to 5 active coupons at a time") 
      end
    end
  
    def prevent_deletion
      errors.add(:base, "Coupons cannot be deleted. They can only be activated or deactivated.")
      throw(:abort)
    end
  end