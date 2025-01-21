class Item < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true, numericality: true
  belongs_to :merchant
  validates :name, :description, :unit_price, presence: true
  has_many :invoice_items, dependent: :destroy
  # has_many :invoices, through: :invoice_items

  def self.sort_by_price
    self.order(unit_price: :asc)
  end

  def self.find_one_item_by_name(name)
    Item.find_all_by_name(name).order("LOWER(name)").first
  end

  def self.find_items_by_price(min_price: 0, max_price: Float::MAX)
    Item.where("unit_price > ? AND unit_price < ?", min_price.to_f, max_price.to_f).order(:name)
  end

  def self.find_one_item_by_price(min_price: 0, max_price: Float::MAX)
    Item.find_items_by_price(min_price: min_price, max_price: max_price).first
  end

  def self.find_all_by_name(name)
    Item.where("name iLIKE ?", "%#{name}%")
  end
end