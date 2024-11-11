class Coupon < ApplicationRecord
  belongs_to :merchant 
  has_many :invoices

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :discount_type, presence: true, inclusion: { in: %w[percent_off dollar_off] }
  validates :discount_value, presence: true, numericality: { greater_than: 0 }

  scope :active, -> { where(status: true)}
  scope :inactive, -> { where(status: false)}

  def self.filter_by_status(status)
    case status
    when 'active'
      active
    when 'inactive'
      inactive
    else
      none
    end
  end
end