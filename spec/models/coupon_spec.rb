require 'rails_helper'

RSpec.describe Coupon, type: :model do
  before(:each) do 
    @merchant = Merchant.create!(name: "Sample Merchant")
  end
  describe 'relationships' do 
    it {should belong_to(:merchant)}
    it {should have_many(:invoices)}
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      coupon = Coupon.new(name: "Sample Coupon", code: "COUPON001",discount_value: 1, active: true, merchant: @merchant)
      expect(coupon).to be_valid
    end

    it 'is not valid without a name' do
      coupon = Coupon.new(name: nil, code: "COUPON001", merchant: @merchant)
      expect(coupon).to_not be_valid
      expect(coupon.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without a code' do
      coupon = Coupon.new(name: "Sample Coupon", code: nil, merchant: @merchant)
      expect(coupon).to_not be_valid
      expect(coupon.errors[:code]).to include("can't be blank")
    end

    it 'is not valid with a duplicate code for the same merchant' do
      Coupon.create!(name: "Sample Coupon", code: "COUPON001",discount_value: 1, active: true, merchant: @merchant)
      coupon = Coupon.new(name: "New Coupon", code: "COUPON001", active: true, merchant: @merchant)
      expect(coupon).to_not be_valid
      expect(coupon.errors[:code]).to include("has already been taken")
    end
  end
end
