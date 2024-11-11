require 'rails_helper'

RSpec.describe Coupon, type: :model do
  let(:merchant) { create(:merchant) }
  let!(:active_coupon) { create(:coupon, :active, merchant: merchant) }
  let!(:inactive_coupon) { create(:coupon, :inactive, merchant: merchant) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
    it { should validate_presence_of(:discount_type) }
    it { should validate_inclusion_of(:discount_type).in_array(%w[percent_off dollar_off]) }
    it { should validate_presence_of(:discount_value) }
    it { should validate_numericality_of(:discount_value).is_greater_than(0) }
  end

  describe 'associations' do 
    it { should belong_to(:merchant) }
    it { should have_many(:invoices) }
  end 
  
  describe 'scopes' do
    it 'can return an active coupon' do
      expect(Coupon.active).to include(active_coupon)
      expect(Coupon.active).not_to include(inactive_coupon)
    end

    it 'can return an inactive coupon' do
      expect(Coupon.inactive).to include(inactive_coupon)
      expect(Coupon.inactive).not_to include(active_coupon)
    end
  end

  describe 'traits' do
    it 'can be created active' do
      expect(active_coupon.status).to be true
    end

    it 'can be created inactive' do
      expect(inactive_coupon.status).to be false
    end

    it 'can have percent_off discount' do
      percent_off = create(:coupon, :percent_off, merchant: merchant)
      expect(percent_off.discount_type).to eq('percent_off')
    end

    it 'can have dollar_off discount' do
      dollar_off = create(:coupon, :dollar_off, merchant: merchant)
      expect(dollar_off.discount_type).to eq('dollar_off')
    end
  end

  describe '.filter_by_status' do
    it 'returns ony active coupons' do
      expect(Coupon.filter_by_status('active')).to contain_exactly(active_coupon)
    end

    it 'returns only inactive coupons' do
      expect(Coupon.filter_by_status('inactive')).to contain_exactly(inactive_coupon)
    end
  end
end