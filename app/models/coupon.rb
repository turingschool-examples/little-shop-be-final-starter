class Coupon < ApplicationRecord
    belongs_to :merchant
    has_many :coupon_uses, dependent: :destroy 
  
    validates :name, presence: true
    validates :code, presence: true, uniqueness: true
    validates :percent_off, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
    validates :dollar_off, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

    def used_count
      coupon_uses.count
    end
  end
  