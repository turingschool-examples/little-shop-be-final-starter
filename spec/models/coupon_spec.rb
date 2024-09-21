require "rails_helper"

RSpec.describe Coupon, type: :model do
  describe '.for_merchant' do
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
end