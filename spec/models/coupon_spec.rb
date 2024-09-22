require "rails_helper"

RSpec.describe Coupon, type: :model do
  let!(:merchant) { Merchant.create(name: "Test Merchant") }
  let!(:active_coupon) { Coupon.create(name: "Active Coupon", code: "ACTIVE123", active: true, discount_type: 'dollar_off', discount_value: 10, merchant: merchant) }
  let!(:inactive_coupon) { Coupon.create(name: "Inactive Coupon", code: "INACTIVE123", active: false, discount_type: 'percentage_off', discount_value: 20, merchant: merchant) }

  describe '.for_merchant_with_status' do
    it 'returns only active coupons for merchant when selecting active' do
      coupons = Coupon.for_merchant_with_status(merchant.id, 'active')
      expect(coupons).to include(active_coupon)
      expect(coupons).not_to include(inactive_coupon)
    end

    it 'returns only inactive coupons for merchant when selecting inactive' do
      coupons = Coupon.for_merchant_with_status(merchant.id, 'inactive')
      expect(coupons).to include(inactive_coupon)
      expect(coupons).not_to include(active_coupon)
    end

    it 'returns all coupons when status is not selected' do
      coupons = Coupon.for_merchant_with_status(merchant.id)
      expect(coupons).to include(active_coupon, inactive_coupon)
    end

    it 'returns all coupons when status is not recognized' do
      coupons = Coupon.for_merchant_with_status(merchant.id, 'unknown')
      expect(coupons).to include(active_coupon, inactive_coupon)
    end
  end

  describe '#activate_coupon' do
    it 'activates the coupon when there are less than 5 active coupons' do
      expect(inactive_coupon.activate_coupon).to be true
      expect(inactive_coupon.reload.active).to be true
    end

    it 'does not activate the coupon and returns false when there are 5 active coupons' do
      5.times { Coupon.create(name: "Active", code: "ACTIVE", active: true, discount_type: 'dollar_off', discount_value: 10, merchant: merchant) }
      expect(inactive_coupon.activate_coupon).to be false
      expect(inactive_coupon.reload.active).to be false
    end
  end

  describe '#exceeds_active_coupon_limit?' do    
    it 'returns true when merchant has 5 active coupon' do
      5.times { Coupon.create(name: "Active", code: "ACTIVE", active: true, discount_type: 'dollar_off', discount_value: 10, merchant: merchant) }
      coupon = Coupon.new(name: "New Coupon", code: "NEW123", active: false, discount_type: 'dollar_off', discount_value: 10, merchant: merchant)
      expect(coupon.exceeds_active_coupon_limit?).to be true
    end
  end

  describe '#code_already_exists?' do
    let(:merchant) { FactoryBot.create(:merchant) }  
    let!(:existing_coupon) { FactoryBot.create(:coupon, code: 'UNIQUECODE', merchant: merchant, discount_type: 'dollar_off', discount_value: 10) }

    it 'returns true when coupon code already exists' do
      expect(existing_coupon.code_already_exists?).to be true
    end

    it 'returns false when coupon code doesnt exist' do
      new_coupon = Coupon.new(code: 'NEWCODE', merchant: merchant)
      expect(new_coupon.code_already_exists?).to be false
    end
  end

end