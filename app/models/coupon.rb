class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :active, inclusion: { in: [true, false] }
  
  def used_count
    invoices.count
  end
end