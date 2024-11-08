class Coupon < ApplicationRecord
    validates :code, presence: true, uniqueness: true
    validates :discount, presence: true, numericality: true
    validates :active, presence: true
    validates :percent_discount, presence: true
    validates :merchant_id, presence: true
    belongs_to :merchant
    belongs_to :invoice, optional: true
end