class Coupon < ApplicationRecord
    belongs_to :merchant
    has_many :invoices

    validates :name, presence: true
    validates :code, presence: true, uniqueness: true
    validates :percent_off, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
    validates :dollar_off, numericality: {greater_than_or_equal_to: 0}, allow_nil: true
    validates :merchant_id, presence: true
    validates :status, inclusion: { in: ["active", "inactive"] }, presence: true

    def self.coupon_usage(coupon)
        Invoice.where(coupon_id: coupon.id).count
    end
end