class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  belongs_to :coupon, optional: true
  has_many :invoice_items, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :status, inclusion: { in: ["shipped", "packaged", "returned"] }
  validate :coupon_must_be_active
end

private

def coupon_must_be_active
  binding.pry
  if coupon && !coupon.active?
    errors.add(:coupon, "must be active.")
  end
end
  