require 'rails_helper'

describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:customers).through(:invoices) }
  end

  describe "class methods" do
    it "should sort merchants by created_at" do
      merchant1 = create(:merchant, created_at: 1.day.ago)
      merchant2 = create(:merchant, created_at: 4.days.ago)
      merchant3 = create(:merchant, created_at: 2.days.ago)

      expect(Merchant.sorted_by_creation).to eq([merchant1, merchant3, merchant2])
    end

    it "should filter merchants by status of invoices" do
      merchant1 = create(:merchant)
      merchant2 = create(:merchant)
      customer = create(:customer)
      create(:invoice, status: "returned", merchant_id: merchant1.id, customer_id: customer.id)
      create_list(:invoice, 5, merchant_id: merchant1.id, customer_id: customer.id)
      create_list(:invoice, 5, merchant_id: merchant2.id, customer_id: customer.id)
      create(:invoice, status: "packaged", merchant_id: merchant2.id, customer_id: customer.id)

      expect(Merchant.filter_by_status("returned")).to eq([merchant1])
      expect(Merchant.filter_by_status("packaged")).to eq([merchant2])
      expect(Merchant.filter_by_status("shipped")).to match_array([merchant1, merchant2])
    end

    it "should retrieve merchant when searching by name" do
      merchant1 = Merchant.create!(name: "Turing")
      merchant2 = Merchant.create!(name: "ring world")
      merchant3 = Merchant.create!(name: "Vera Wang")

      expect(Merchant.find_one_merchant_by_name("ring")).to eq(merchant2)
      expect(Merchant.find_all_by_name("ring")).to eq([merchant1, merchant2])
    end
  end

  describe 'instance methods' do
    it "#coupons_count should return the total count of coupons for the merchant" do
      merchant = create(:merchant)
      merchant2 = create(:merchant)

      coupon1 = create(:coupon, merchant: merchant)
      coupon2 = create(:coupon, merchant: merchant)
      coupon3 = create(:coupon, merchant: merchant2)

      expect(merchant.coupons_count).to eq(2)
      expect(merchant2.coupons_count).to eq(1)
    end

    it "#invoice_coupon_count should return the count of invoices with coupons applied" do
      merchant = create(:merchant)
      merchant2 = create(:merchant)

      customer1 = create(:customer)
      customer2 = create(:customer)

      coupon1 = create(:coupon, merchant: merchant)
      coupon2 = create(:coupon, merchant: merchant2)

      invoice1 = create(:invoice, customer: customer1, merchant: merchant, coupon: coupon1)
      invoice2 = create(:invoice, customer: customer2, merchant: merchant, coupon: coupon1)
      invoice3 = create(:invoice, customer: customer2, merchant: merchant)
      invoice4 = create(:invoice, customer: customer1, merchant: merchant2, coupon: coupon2)

      expect(merchant.invoice_coupon_count).to eq(2)
      expect(merchant2.invoice_coupon_count).to eq(1)
    end

    it "#item_count should return the count of items for a merchant" do
      merchant = Merchant.create!(name: "My merchant")
      merchant2 = Merchant.create!(name: "My other merchant")

      create_list(:item, 8, merchant_id: merchant.id)
      create_list(:item, 4, merchant_id: merchant2.id)

      expect(merchant.item_count).to eq(8)
      expect(merchant2.item_count).to eq(4)
    end

    it "#distinct_customers should return all customers for a merchant" do
      merchant1 = create(:merchant)
      customer1 = create(:customer)
      customer2 = create(:customer)
      customer3 = create(:customer)

      merchant2 = create(:merchant)

      create_list(:invoice, 3, merchant_id: merchant1.id, customer_id: customer1.id)
      create_list(:invoice, 2, merchant_id: merchant1.id, customer_id: customer2.id)
      create_list(:invoice, 2, merchant_id: merchant2.id, customer_id: customer3.id)

      expect(merchant1.distinct_customers).to match_array([customer1, customer2])
      expect(merchant2.distinct_customers).to eq([customer3])
    end

    it "#invoices_filtered_by_status should return all invoices for a customer that match the given status" do
      merchant = create(:merchant)
      other_merchant = create(:merchant)
      customer = create(:customer)

      inv_1_shipped = Invoice.create!(status: "shipped", merchant: merchant, customer: customer)
      inv_2_shipped = Invoice.create!(status: "shipped", merchant: merchant, customer: customer)
      inv_3_packaged = Invoice.create!(status: "packaged", merchant: merchant, customer: customer)
      inv_4_packaged = Invoice.create!(status: "packaged", merchant: other_merchant, customer: customer)
      inv_5_returned = Invoice.create!(status: "returned", merchant: merchant, customer: customer)

      expect(merchant.invoices_filtered_by_status("shipped")).to match_array([inv_1_shipped, inv_2_shipped])
      expect(merchant.invoices_filtered_by_status("packaged")).to eq([inv_3_packaged])
      expect(merchant.invoices_filtered_by_status("returned")).to eq([inv_5_returned])
      expect(other_merchant.invoices_filtered_by_status("packaged")).to eq([inv_4_packaged])
    end
  end

  describe '#fetch_invoices' do
    it 'returns all invoices when no status is provided' do
      merchant = FactoryBot.create(:merchant)
      customer = FactoryBot.create(:customer)

      invoice1 = FactoryBot.create(:invoice, merchant: merchant, customer: customer, status: 'packaged')
      invoice2 = FactoryBot.create(:invoice, merchant: merchant, customer: customer, status: 'shipped')

      invoices = merchant.fetch_invoices
      expect(invoices.count).to eq(2)
      expect(invoices).to include(invoice1, invoice2)
    end

    it 'filters invoices by status when a status is provided' do
      merchant = FactoryBot.create(:merchant)
      customer = FactoryBot.create(:customer)

      FactoryBot.create(:invoice, merchant: merchant, customer: customer, status: 'packaged')
      shipped_invoice = FactoryBot.create(:invoice, merchant: merchant, customer: customer, status: 'shipped')

      shipped_invoices = merchant.fetch_invoices('shipped')
      expect(shipped_invoices.count).to eq(1)
      expect(shipped_invoices.first.status).to eq('shipped')
      expect(shipped_invoices.first).to eq(shipped_invoice)
    end
  end
end
