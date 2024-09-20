class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices
  validates :code, uniqueness: { scope: :merchant_id, message: "has already been taken" }
  validates :name, :code, presence: true
  validates :active, inclusion: { in: [true, false] }
end
