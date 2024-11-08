class Coupon < ApplicationRecord
  validates_presence_of :name
  belongs_to :merchant
  has_many :invoices
end