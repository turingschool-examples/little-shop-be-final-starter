class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices
  
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :active, presence: true
  validates :merchant_id, presence: true
  validate :discount_type_constraints
end

def discount_type_constraints
# adding logic here
end 
