require 'rails_helper'

RSpec.describe Coupon, type: :model do
  before :each do
    @merchant1 = Merchant.create!(name: "Walmart")
    @coupon = Coupon.create!(name: "Discount A", code: "SAVE10", value: 10, active: true, merchant: @merchant1)
  end

  it { should belong_to(:merchant) }
  it { should have_many(:invoices) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:code) }

  it "validates uniqueness of code" do
    Coupon.create!(name: "Coupon1", code: "Code1", value: 10, active: true, merchant: @merchant1)
    should validate_uniqueness_of(:code) 
  end
  
  it { should validate_numericality_of(:value).is_greater_than(0) }

  describe "used_count" do
    it "returns the count of times the coupon has been used" do
      Invoice.create!(merchant: @merchant1, coupon: @coupon, status: "shipped", customer: Customer.create!(first_name: "Bob", last_name: "Lobla"))
      Invoice.create!(merchant: @merchant1, coupon: @coupon, status: "packaged", customer: Customer.create!(first_name: "Sally", last_name: "Schnieder"))

      expect(@coupon.used_count).to eq(2)
    end
  end
end