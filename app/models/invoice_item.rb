class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  validates :item_id, presence: true
end