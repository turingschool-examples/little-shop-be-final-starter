class Coupon < ApplicationRecord
  belongs_to :merchant
  
  validates :name, presence: true
  validates :code, presence: true
  validates :active, presence: true
  validates :merchant_id, presence: true
  validate :discount_type_constraints
end

def discount_type_constraints
# adding logic here
end 
