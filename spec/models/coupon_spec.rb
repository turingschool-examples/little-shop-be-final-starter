require 'rails_helper'

RSpec.describe Coupon, type: :model do
  before(:each) do
    @merchant = FactoryBot.create(:merchant)
    @merchant1 = FactoryBot.create(:merchant)
    @merchant2 = FactoryBot.create(:merchant)
    @customer = FactoryBot.create(:customer)

    @coupon = FactoryBot.create(:coupon, merchant: @merchant, active: false, discount_type: 'percent', discount_value: 10)
    @coupon1 = FactoryBot.create(:coupon, merchant: @merchant1, code: 'SAVE10')
    @coupon2 = FactoryBot.create(:coupon, merchant: @merchant1, code: 'DISCOUNT20')
    @coupon3 = FactoryBot.create(:coupon, merchant: @merchant2, code: 'PROMO15')

    @invoice1 = FactoryBot.create(:invoice, customer: @customer, merchant: @merchant1, coupon: @coupon1)
    @invoice2 = FactoryBot.create(:invoice, customer: @customer, merchant: @merchant1, coupon: @coupon1)
    @invoice3 = FactoryBot.create(:invoice, customer: @customer, merchant: @merchant1, coupon: @coupon2)

    @coupon_active1 = FactoryBot.create(:coupon, merchant: @merchant1, active: true)
    @coupon_active2 = FactoryBot.create(:coupon, merchant: @merchant1, active: true)
    @coupon_inactive = FactoryBot.create(:coupon, merchant: @merchant1, active: false)
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

  describe '#update_with_status' do
    context 'when valid parameters are provided' do
      it 'updates the coupon attributes successfully' do
        result = @coupon.update_with_status(active: true, discount_value: 20)
        
        expect(result).to be_truthy
        expect(@coupon.reload.active).to eq(true)
        expect(@coupon.discount_value).to eq(20)
      end
    end

    context 'when invalid parameters are provided' do
      it 'does not update the coupon and returns false' do
        result = @coupon.update_with_status(discount_type: 'invalid_type')

        expect(result).to be_falsey
        expect(@coupon.reload.discount_type).not_to eq('invalid_type')
        expect(@coupon.errors.full_messages).to include('Discount type is not included in the list')
      end
    end

    context 'when validations prevent update' do
      it 'does not update the coupon when merchant exceeds active coupon limit' do
    
        5.times { FactoryBot.create(:coupon, merchant: @merchant, active: true) }
        result = @coupon.update_with_status(active: true)
    
        expect(result).to be_falsey
        expect(@coupon.reload.active).to eq(false)
        expect(@coupon.errors.full_messages).to include('Merchant cannot have more than 5 active coupons')
      end
    end

    describe '.by_merchant' do
      context 'without active status filter' do
        it 'returns all coupons for the specified merchant' do
          coupons = Coupon.by_merchant(@merchant1.id)
          expect(coupons).to include(@coupon_active1, @coupon_active2, @coupon_inactive)
          expect(coupons.count).to eq(5)
        end
      end
  
      context 'with active=true filter' do
        it 'returns only active coupons for the specified merchant' do
          coupons = Coupon.by_merchant(@merchant1.id, true)
          expect(coupons).to include(@coupon_active1, @coupon_active2)
          expect(coupons).not_to include(@coupon_inactive)
          expect(coupons.count).to eq(2)
        end
      end
  
      describe '.by_merchant' do
        context 'with active=false filter' do
          it 'returns only inactive coupons for the specified merchant' do
            
            merchant = FactoryBot.create(:merchant)
      
            active_coupon = FactoryBot.create(:coupon, merchant: merchant, active: true)
            inactive_coupon1 = FactoryBot.create(:coupon, merchant: merchant, active: false)
            inactive_coupon2 = FactoryBot.create(:coupon, merchant: merchant, active: false)
    
            coupons = Coupon.by_merchant(merchant.id, false)
      
            expect(coupons).to include(inactive_coupon1, inactive_coupon2)
            expect(coupons).not_to include(active_coupon)
            expect(coupons.count).to eq(2)
          end
        end
      end
    end
  end
end
