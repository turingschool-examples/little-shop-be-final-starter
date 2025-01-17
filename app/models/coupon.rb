class Coupon < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
  validates :dollar_off, presence: true, numericality: { only_float: true }, allow_blank: true
  validates :percent_off, presence: true, numericality: { only_integer: true }, allow_blank: true
  validates :status, presence: true, inclusion: { in: ["active", "inactive"] }
  validates :merchant_id, presence: true, numericality: { only_integer: true }
  belongs_to :merchant
  has_many :invoices
end