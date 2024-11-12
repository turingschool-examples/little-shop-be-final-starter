require "rails_helper"

RSpec.describe Invoice do
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should belong_to :customer }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:status).in_array(%w(shipped packaged returned)) }
  end

  describe '#total_with_discount' do
    it 'should correctly apply percent_off coupon to items from the merchant' do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      customer = create(:customer)
      coupon = create(:coupon, merchant: merchant1, discount_type: 'percent_off', discount_value: 20)

      invoice = create(:invoice, merchant: merchant1, customer: customer, coupon: coupon)
      
      item1 = create(:item, merchant: merchant1, unit_price: 50)
      item2 = create(:item, merchant: merchant2, unit_price: 30)

      InvoiceItem.create!(invoice: invoice, item: item1, quantity: 2, unit_price: 50)
      InvoiceItem.create!(invoice: invoice, item: item2, quantity: 3, unit_price: 30) 

      expect(invoice.total_amount).to eq(100)
      expect(invoice.total_after_discount).to eq(80)
    end

    it 'should not reduce total below zero for dollar_off coupon' do
      merchant = create(:merchant)
      customer = create(:customer)
      coupon = create(:coupon, merchant: merchant, discount_type: 'dollar_off', discount_value: 300)

      invoice = create(:invoice, merchant: merchant, customer: customer, coupon: coupon)
      item = create(:item, merchant: merchant, unit_price: 50)

      InvoiceItem.create!(invoice: invoice, item: item, quantity: 2, unit_price: 50)

      expect(invoice.total_amount).to eq(100)
      expect(invoice.total_after_discount).to eq(0)
    end

    it 'should return the total amount if the coupon discount type is invalid' do
      merchant = create(:merchant)
      customer = create(:customer)

      coupon = create(:coupon, merchant: merchant, discount_type: 'percent_off', discount_value: 50)

      coupon.update_column(:discount_type, 'invalid_type')

      invoice = create(:invoice, merchant: merchant, customer: customer, coupon: coupon)
      item = create(:item, merchant: merchant, unit_price: 50)

      InvoiceItem.create!(invoice: invoice, item: item, quantity: 2, unit_price: 50)

      expect(invoice.total_amount).to eq(100)
      expect(invoice.total_after_discount).to eq(100)
    end
  end
end