require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe 'associations' do
    it { should belong_to :merchant }
    it { should belong_to :customer }
    it { should belong_to(:coupon).optional }
    it { should have_many(:invoice_items).dependent(:destroy)}
    it { should have_many(:transactions).dependent(:destroy)}
  end 

  describe 'validations' do
    it { should validate_inclusion_of(:status).in_array(%w(shipped packaged returned)) }
  end

  describe 'using FactoryBot' do
    before(:each) do
      @merchant = FactoryBot.create(:merchant)
      @customer = FactoryBot.create(:customer)
      @coupon= FactoryBot.create(:coupon, merchant: @merchant)
      @invoice_with_coupon = FactoryBot.create(:invoice, merchant: @merchant, customer: @customer, coupon: @coupon)
      @invoice_without_coupon = FactoryBot.create(:invoice, merchant: @merchant, customer: @customer, coupon: nil)
    end

    it 'can be created without a coupon' do
      expect(@invoice_without_coupon.coupon).to be(nil)
    end

    it 'can be created with a coupon' do
      expect(@invoice_with_coupon.coupon).to be(@coupon)
    end
  end
end