require "rails_helper"

RSpec.describe Coupon do
  describe 'associations' do
    it "can be associated to a merchant" do 
      test_merchant = Merchant.create!(name: "Test Merchant")
      test_coupon = Coupon.create!(
        full_name: "My first test coupon.",
        code: "Ten percent",
        percent_off: 10,
        active: false,
        merchant_id: test_merchant.id
      )
      expect(test_coupon.merchant).to eq(test_merchant)
      # expect(test_merchant.coupons).to include(test_coupon) 
    end
  end
    # it { should belong_to :merchant }
    # it { should validate_inclusion_of(:status).in_array(%w(shipped packaged returned)) }
  
end

# it "is valid with all attributes" do
#   poster = Poster.create(
#       name: "REGRET",
#       description: "Hard work rarely pays off.",
#       price: 89.00,
#       year: 2018,
#       vintage: true,
#       img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
#       )

#   expect(poster).to be_valid
# end

#   end

#   describe 'validations' do
#     it ...
    
#   end

#   describe 'custom instance methods' do
#     it ...
    
#   end

# end

# remaning things to test...
# validations
  # describe associations
# discount_type_constraints