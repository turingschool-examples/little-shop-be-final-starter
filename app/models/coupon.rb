class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices
  validates :code, uniqueness: true
  validates :name, :code, presence: true
end
