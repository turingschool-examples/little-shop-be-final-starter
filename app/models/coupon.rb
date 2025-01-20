class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices
  
  validates :full_name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :active, inclusion: { in: [true, false]}
  validates :merchant_id, presence: true
  validate :discount_type_constraints
  validates :usage_count, presence: true
end

private

def discount_type_constraints
  if !percent_off.present? && !dollar_off.present?
    errors.add(:base, "one discount type (percent or dollar off) must be specified.")
  elsif percent_off.present? && dollar_off.present?
    errors.add(:base, "only one discount type (percent or dollar off) can be specified at a time.")
  end
end 
