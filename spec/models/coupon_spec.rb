require "rails_helper"

RSpec.describe Coupon, type: :model do
  describe '#for_merchant' do
    let(:merchant_1) { FactoryBot.create(:merchant) }
    let(:merchant_2) { FactoryBot.create(:merchant) }

    let!(:merchant_1_coupons) { FactoryBot.create_list(:coupon, 3, merchant: merchant_1)}
    let!(:merchant_2_coupons) { FactoryBot.create_list(:coupon, 4, merchant: merchant_2)}

    it 'returns coupons for the specified merchant' do
      result = Coupon.for_merchant(merchant_1.id)

      expect(result.count).to eq(3)
      expect(result).to match_array(merchant_1_coupons)
      expect(result).not_to include(*merchant_2_coupons)
    end
  end

  describe '#activate_coupon' do
    let(:merchant) { FactoryBot.create(:merchant) }
    let!(:active_coupons) { FactoryBot.create_list(:coupon, 4, merchant: merchant, active: true) }
    let(:inactive_coupon) { FactoryBot.create(:coupon, merchant: merchant, active: false, name: "Inactive Coupon", code: "INACTIVE123") }

    it 'activates the coupon when there are less than 5 active coupons' do
      expect(inactive_coupon.activate_coupon).to be_truthy
      expect(inactive_coupon.reload.active).to be true
    end

    it 'does not activate the coupon and returns false when there are 5 active coupons' do
      FactoryBot.create(:coupon, merchant: merchant, active: true)
      expect(inactive_coupon.activate_coupon).to be_falsey
      expect(inactive_coupon.reload.active).to be false
    end
  end

  describe '#exceeds_active_coupon_limit?' do
    let(:merchant) { FactoryBot.create(:merchant) }
    let!(:active_coupons) { FactoryBot.create_list(:coupon, 3, merchant: merchant, active: true) }  
    
    it 'returns true when merchant has 5 active coupon' do
      coupon_1 = FactoryBot.create(:coupon, merchant: merchant, active: true)
      expect(coupon_1.exceeds_active_coupon_limit?).to be false
      coupon_2 = FactoryBot.create(:coupon, merchant: merchant, active: true)
      expect(coupon_2.exceeds_active_coupon_limit?).to be true
    end
  end

  describe '#code_already_exists?' do
    let(:merchant) { FactoryBot.create(:merchant) }  
    let!(:existing_coupon) { FactoryBot.create(:coupon, code: 'UNIQUECODE', merchant: merchant) }

    it 'returns true when coupon code already exists' do
      expect(existing_coupon.code_already_exists?).to be true
    end

    it 'returns false when coupon code doesnt exist' do
      new_coupon = Coupon.new(code: 'NEWCODE', merchant: merchant)
      expect(new_coupon.code_already_exists?).to be false
    end
  end

end