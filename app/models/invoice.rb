class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant
  belongs_to :coupon, optional: true
  has_many :invoice_items, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :customer_id, presence: true
  validates :merchant_id, presence: true
  validates :status, inclusion: { in: ["shipped", "packaged", "returned"] }, presence: true
  validates :coupon_id, allow_nil: true, presence: true
end