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
    context 'when the coupon exists for the specified merchant' do
      it 'returns the coupon' do
        result = Coupon.find_by_merchant_and_id(@merchant1.id, @coupon1.id)
        expect(result).to eq(@coupon1)
      end
    end

    context 'when the coupon does not belong to the specified merchant' do
      it 'returns nil' do
        result = Coupon.find_by_merchant_and_id(@merchant1.id, @coupon3.id)
        expect(result).to be_nil
      end
    end

    context 'when the coupon does not exist' do
      it 'returns nil' do
        result = Coupon.find_by_merchant_and_id(@merchant1.id, 9999)
        expect(result).to be_nil
      end
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

  context 'when the coupon code is not unique' do
    it 'is not valid' do
      FactoryBot.create(:coupon, merchant: @merchant1, code: 'SAVEMONEY')
      duplicate_coupon = FactoryBot.build(:coupon, merchant: @merchant2, code: 'SAVEMONEY')

      expect(duplicate_coupon.valid?).to be_falsey
      expect(duplicate_coupon.errors[:code]).to include('has already been taken')
    end
  end

  context 'when a merchant has 5 active coupons' do
    before(:each) do
      @merchant = FactoryBot.create(:merchant)
      FactoryBot.create_list(:coupon, 5, merchant: @merchant, active: true)
    end

    it 'does not allow creating a 6th active coupon' do
      new_coupon = FactoryBot.build(:coupon, merchant: @merchant, active: true)
      expect(new_coupon.valid?).to be_falsey
      expect(new_coupon.errors[:base]).to include('Merchant cannot have more than 5 active coupons')
    end

    it 'allows creating an inactive coupon' do
      new_coupon = FactoryBot.build(:coupon, merchant: @merchant, active: false)
      expect(new_coupon.valid?).to be_truthy
    end

    it 'does not allow activating a 6th coupon if there are already 5 active coupons' do
      inactive_coupon = FactoryBot.create(:coupon, merchant: @merchant, active: false)
      result = inactive_coupon.update_with_status({ active: true })
      expect(result).to be false
      expect(inactive_coupon.errors[:base]).to include('Merchant cannot have more than 5 active coupons')
    end
  end

  describe '#update_with_status' do
    it 'updates the coupon attributes without changing active status' do
      expect(@coupon1.update_with_status({ name: 'New Name' })).to be true
      expect(@coupon1.reload.name).to eq('New Name')
    end

    it 'updates the active status when active param is present' do
      result = @coupon1.update_with_status({ active: false })
      expect(result).to be true
      expect(@coupon1.reload.active).to be false
    end
  end

  describe '.by_merchant' do
    it 'returns coupons for the specified merchant' do
      coupons = Coupon.by_merchant(@merchant1.id)
      expect(coupons).to include(@coupon1, @coupon2)
      expect(coupons).not_to include(@coupon3)
    end

    it 'returns an empty array if no coupons exist for the merchant' do
      coupons = Coupon.by_merchant(9999)
      expect(coupons).to be_empty
    end
  end

  describe '.create_for_merchant' do
    it 'creates a coupon for an existing merchant' do
      result = Coupon.create_for_merchant(@merchant1.id, { name: 'New Coupon', code: 'NEWCODE', discount_value: 10, discount_type: 'percent' })
      expect(result).to be_persisted
      expect(result.merchant).to eq(@merchant1)
    end

    it 'returns nil if the merchant does not exist' do
      result = Coupon.create_for_merchant(9999, { name: 'Invalid Coupon', code: 'INVALID', discount_value: 10, discount_type: 'percent' })
      expect(result).to be_nil
    end
  end
end
