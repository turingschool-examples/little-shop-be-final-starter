require 'rails_helper'

RSpec.describe Coupon, type: :model do
  before(:each) do
    @merchant1 = FactoryBot.create(:merchant)
    @merchant2 = FactoryBot.create(:merchant)
    @customer = FactoryBot.create(:customer)

    @coupon1 = FactoryBot.create(:coupon, merchant: @merchant1, code: 'SAVE10')
    @coupon2 = FactoryBot.create(:coupon, merchant: @merchant1, code: 'DISCOUNT20')
    @coupon3 = FactoryBot.create(:coupon, merchant: @merchant2, code: 'PROMO15')

    @invoice1 = FactoryBot.create(:invoice, customer: @customer, merchant: @merchant1, coupon: @coupon1)
    @invoice2 = FactoryBot.create(:invoice, customer: @customer, merchant: @merchant1, coupon: @coupon1)
    @invoice3 = FactoryBot.create(:invoice, customer: @customer, merchant: @merchant1, coupon: @coupon2)
  end

  describe 'associations' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoices) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:coupon) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
    it { should validate_presence_of(:discount_value) }
    it { should validate_inclusion_of(:discount_type).in_array(['percent', 'dollar']) }
  end

  describe '.find_by_merchant_and_id' do
    it 'returns the coupon for the specified merchant' do
      result = Coupon.find_by_merchant_and_id(@merchant1.id, @coupon1.id)
      expect(result).to eq(@coupon1)
    end

    it 'returns nil if the coupon does not belong to the specified merchant' do
      result = Coupon.find_by_merchant_and_id(@merchant1.id, @coupon3.id)
      expect(result).to be_nil
    end

    it 'returns nil if the coupon does not exist' do
      result = Coupon.find_by_merchant_and_id(@merchant1.id, 9999)
      expect(result).to be_nil
    end
  end

  describe '#usage_count' do
    it 'returns the correct count of associated invoices' do
      expect(@coupon1.usage_count).to eq(2)
    end

    it 'returns 0 when there are no associated invoices' do
      new_coupon = FactoryBot.create(:coupon, merchant: @merchant1)
      expect(new_coupon.usage_count).to eq(0)
    end
  end
end