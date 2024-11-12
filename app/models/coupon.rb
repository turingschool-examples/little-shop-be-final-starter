class Coupon < ApplicationRecord
  belongs_to :merchant 
  has_many :invoices

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :discount_type, presence: true, inclusion: { in: %w[percent_off dollar_off] }
  validates :discount_value, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: ["active", "inactive"] }
  
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }
  scope :filter_by_status, ->(status) { where(status: status) }
end