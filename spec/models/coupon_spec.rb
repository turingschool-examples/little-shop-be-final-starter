require "rails_helper"

RSpec.describe Coupon do
  describe 'associations' do
    it { should belong_to :merchant }
  end

  describe 'validations' do
    it "is valid when all attributes are present and valid" do
      test_merchant = Merchant.create!(name: "Test Merchant")
      test_coupon = Coupon.create!(
        full_name: "My first test coupon.",
        code: "Ten percent",
        percent_off: 10,
        active: false,
        merchant_id: test_merchant.id
      )
      expect(test_coupon).to be_valid
      expect(test_coupon.persisted?).to be true
    end

    it "is invalid without a name" do
      test_merchant = Merchant.create!(name: "Test Merchant")
      test_coupon = Coupon.new(
        full_name: nil,
        code: "Ten percent",
        percent_off: 10,
        active: false,
        merchant_id: test_merchant.id
      )
      expect(test_coupon).to_not be_valid
      expect(test_coupon.errors[:full_name]).to include("can't be blank")
    end

    it "is invalid without a code" do
      test_merchant = Merchant.create!(name: "Test Merchant")
      test_coupon = Coupon.new(
        full_name: "My first test coupon.",
        code: nil,
        percent_off: 10,
        active: false,
        merchant_id: test_merchant.id
      )
      expect(test_coupon).to_not be_valid
      expect(test_coupon.errors[:code]).to include("can't be blank")
    end

    it "is invalid if the code is not unique" do
      test_merchant = Merchant.create!(name: "Test Merchant")
      test_coupon = Coupon.create!(
        full_name: "My first test coupon.",
        code: "Ten percent",
        percent_off: 10,
        active: false,
        merchant_id: test_merchant.id
      )
      test_coupon2 = Coupon.new(
        full_name: "My second test coupon.",
        code: "Ten percent",
        percent_off: 10,
        active: false,
        merchant_id: test_merchant.id
      )
      expect(test_coupon2).to_not be_valid
      expect(test_coupon2.errors[:code]).to include("has already been taken")
    end
  end

    
    
    # it { should validate_inclusion_of(:status).in_array(%w(shipped packaged returned)) }
  
end

 


#   describe 'custom instance methods' do
#     it ...
    
#   end

# end

# remaning things to test...
# validations
  # describe associations
# discount_type_constraints