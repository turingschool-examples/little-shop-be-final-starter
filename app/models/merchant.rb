class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :customers, through: :invoices
  has_many :coupons, dependent: :destroy
  # has_many :invoice_items, through: :invoices
  # has_many :transactions, through: :invoices

  def self.sorted_by_creation
    Merchant.order("created_at DESC")
  end

  def self.filter_by_status(status)
    self.joins(:invoices).where("invoices.status = ?", status).select("distinct merchants.*")
  end

  def item_count
    items.count
  end

  def distinct_customers
    # self.customers.distinct # This is possible due to the additional association on line 5
    
    # SQL option: SELECT DISTINCT * FROM customers JOIN invoices ON invoices.customer_id = customers.id 
    #             JOIN merchants ON merchants.id = invoices.customer_id 
    #             WHERE merchants.id = #{self.id}"
    
    # AR option without additional association
    Customer
      .joins(invoices: :merchant)
      .where("merchants.id = ?", self.id).distinct
  end

  def invoices_filtered_by_status(status)
    invoices.where(status: status)
  end

  def self.find_all_by_name(name)
    Merchant.where("name iLIKE ?", "%#{name}%")
  end

  def self.find_one_merchant_by_name(name)
    Merchant.find_all_by_name(name).order("LOWER(name)").first
  end
end