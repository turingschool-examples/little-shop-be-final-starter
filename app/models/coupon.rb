class Coupon < ApplicationRecord
    belongs_to :merchant
    has_many :coupon_uses, dependent: :destroy 
  
    validates :name, presence: true
    validates :code, presence: true, uniqueness: true
    validate :percent_off_or_dollar_off
  
  def used_count
    coupon_uses.count
  end
  
  private
    def percent_off_or_dollar_off
      unless percent_off.present? ^ dollar_off.present?
        errors.add(:base, "You must provide either percent_off or dollar_off.")
      end
    end
end

