class Coupon < ApplicationRecord
  belongs_to :merchant

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
end