# bundle exec rspec spec/models/coupon_use_spec.rb

require 'rails_helper'

RSpec.describe CouponUse, type: :model do
  let(:merchant) { create(:merchant) }
  let(:customer) { create(:customer) }
  let(:coupon) { create(:coupon, merchant: merchant) }

  describe 'relationships' do
    it { should belong_to(:coupon) }
    it { should belong_to(:customer) }
  end

  describe 'instance methods' do
    it '#increment_coupon_used_count increments the coupon used_count' do
      expect(coupon.used_count).to eq(0)

      create(:coupon_use, coupon: coupon, customer: customer)

      expect(coupon.used_count).to eq(1)

      create(:coupon_use, coupon: coupon, customer: customer)
      expect(coupon.used_count).to eq(2)
    end
  end
end
