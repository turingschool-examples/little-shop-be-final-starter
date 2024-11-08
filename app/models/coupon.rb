class Coupon < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    validates :discount, presence: true, numericality: true
    validates :active, inclusion: { in: [true,false]}
    validates :percent_discount, inclusion: { in: [true,false]}
    validates :merchant_id, presence: true
    belongs_to :merchant
    belongs_to :invoice, optional: true
end