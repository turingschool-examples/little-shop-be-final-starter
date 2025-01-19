require "rails_helper"

RSpec.describe Coupon do
  describe 'associations' do
    it { should belong_to :merchant }
  end

  describe "required presence attribute validations" do
    it { should validate_presence_of :full_name }
    it { should validate_presence_of :code }
    it { should validate_presence_of :merchant_id }
  end

  describe "specific attribute validations" do
    let(:merchant) { create(:merchant) }
    it "is valid when all attributes are present and valid" do
      coupon = create(:coupon, merchant: merchant, percent_off: 15.0, dollar_off: nil)
       
      expect(coupon).to be_valid
      expect(coupon.persisted?).to be true
    end

    it "is invalid if the code is not unique" do
      coupon1 = create(:coupon, merchant: merchant, code: "UNIQUECODE")
      coupon2 = build(:coupon, merchant: merchant, code: "UNIQUECODE")

      expect(coupon2).to_not be_valid
      expect(coupon2.errors[:code]).to include("has already been taken")
    end

    xit "is valid when active is true" do
      test_merchant = Merchant.create!(name: "Test Merchant")
      test_coupon = Coupon.create!(
        full_name: "My first test coupon.",
        code: "Ten percent",
        percent_off: 10,
        active: true,
        merchant_id: test_merchant.id
      )
      expect(test_coupon).to be_valid
    end
    
    xit "is valid when active is false" do
      test_merchant = Merchant.create!(name: "Test Merchant")
      test_coupon = Coupon.create!(
        full_name: "My first test coupon.",
        code: "Ten percent",
        percent_off: 10,
        active: false,
        merchant_id: test_merchant.id
      )
      expect(test_coupon).to be_valid
    end

    xit "is invalid when active is nil" do
      test_merchant = Merchant.create!(name: "Test Merchant")
      test_coupon = Coupon.new(
        full_name: "My first test coupon.",
        code: "Ten percent",
        percent_off: 10,
        active: nil,
        merchant_id: test_merchant.id
      )
      expect(test_coupon).to_not be_valid
      expect(test_coupon.errors[:active]).to include("is not included in the list")
    end

    xit "is valid when percent_off is not nill and dollar_off is nil" do
      test_merchant = Merchant.create!(name: "Test Merchant")
      test_coupon = Coupon.create!(
        full_name: "My first test coupon.",
        code: "Ten percent",
        percent_off: 10,
        dollar_off: nil,
        active: false,
        merchant_id: test_merchant.id
      )
      expect(test_coupon).to be_valid
    end

    xit "is valid when dollar_off is not nill and percent_off is nil" do
      test_merchant = Merchant.create!(name: "Test Merchant")
      test_coupon = Coupon.create!(
        full_name: "My first test coupon.",
        code: "Ten dollars off",
        percent_off: nil,
        dollar_off: 10,
        active: false,
        merchant_id: test_merchant.id
      )
      expect(test_coupon).to be_valid
    end

    xit "is invalid when both dollar_off and percent_off are nil" do
      test_merchant = Merchant.create!(name: "Test Merchant")
      test_coupon = Coupon.new(
        full_name: "My first test coupon.",
        code: "Ten dollars off",
        percent_off: nil,
        dollar_off: nil,
        active: false,
        merchant_id: test_merchant.id
      )
      expect(test_coupon).to_not be_valid
      expect(test_coupon.errors[:base]).to include("one discount type (percent or dollar off) must be specified.")
    end

    xit "is invalid when both dollar_off and percent_off are nil" do
      test_merchant = Merchant.create!(name: "Test Merchant")
      test_coupon = Coupon.new(
        full_name: "My first test coupon.",
        code: "Ten dollars off",
        percent_off: 10,
        dollar_off: 10,
        active: false,
        merchant_id: test_merchant.id
      )
      expect(test_coupon).to_not be_valid
      expect(test_coupon.errors[:base]).to include("only one discount type (percent or dollar off) can be specified at a time.")
    end
  end  
end

 