class Coupon < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
  validates :dollar_off, allow_nil: true, numericality: { only_float: true }
  validates :percent_off, allow_nil: true, numericality: { only_integer: true }
  validate :confirm_discount_type_present
  validates :status, presence: true, inclusion: { in: ["active", "inactive"] }
  validates :merchant_id, presence: true

  belongs_to :merchant
  has_many :invoices

  def self.invoice_coupon_count(coupon)
    Invoice.where(coupon_id: coupon.id).count
  end

  private

  def confirm_discount_type_present
    if dollar_off.nil? && percent_off.nil?
      errors.add(:base, "Either dollar_off or percent_off must have a value")
    elsif !dollar_off.nil? && !percent_off.nil?
      errors.add(:base, "Only dollar_off or percent_off can have a value")
    end
  end
end