class Customer < ApplicationRecord
  has_many :invoices
  has_many :coupon_uses
end