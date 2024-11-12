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

  describe "update_status" do
    it "activates the coupon if it is not already active and the merchant has less than 5 active coupons" do
      expect(@coupon.update_status(true)).to be_truthy
      expect(@coupon.reload.active).to be_truthy
    end

    it "does not activate the coupon if there are already 5 active coupons" do
      @merchant1.coupons.create!(name: "Discount B", code: "SAVE20", value: 20, active: true)
      @merchant1.coupons.create!(name: "Discount C", code: "SAVE30", value: 30, active: true)
      @merchant1.coupons.create!(name: "Discount D", code: "SAVE40", value: 40, active: true)
      @merchant1.coupons.create!(name: "Discount E", code: "SAVE50", value: 50, active: true)
      @coupon2 = @merchant1.coupons.create!(name: "Discount F", code: "SAVE60", value: 60, active: false)
      
      expect(@coupon2.update_status(true)).to be_falsey
      expect(@coupon2.reload.active).to be_falsey
      expect(@coupon2.errors[:base]).to include("Merchant already has 5 active coupons")
    end

    it "deactivates the coupon if it is active" do
      @coupon.update!(active: true)
      expect(@coupon.update_status(false)).to be_truthy
      expect(@coupon.reload.active).to be_falsey
    end

    it "does not deactivate the coupon if there are pending invoices" do
      customer = Customer.create!(first_name: "Bob", last_name: "Lobla")
      invoice = @merchant1.invoices.create!(customer_id: customer.id, status: "packaged", coupon_id: @coupon.id)
      
      expect(@coupon.update_status(false)).to be_falsey
      expect(@coupon.errors[:base]).to include("Coupon cannot be deactivated due to pending invoices")
    end
  end

  describe "can_activate_coupon?" do
    it "returns false if the merchant already has 5 active coupons" do
      @merchant1.coupons.create!(name: "Discount B", code: "SAVE20", value: 20, active: true)
      @merchant1.coupons.create!(name: "Discount C", code: "SAVE30", value: 30, active: true)
      @merchant1.coupons.create!(name: "Discount D", code: "SAVE40", value: 40, active: true)
      @merchant1.coupons.create!(name: "Discount E", code: "SAVE50", value: 50, active: true)
      @coupon2 = @merchant1.coupons.create!(name: "Discount F", code: "SAVE60", value: 60, active: false)
      
      expect(@coupon2.send(:can_activate_coupon?)).to be_falsey
    end

    it "returns true if the merchant has less than 5 active coupons" do
      expect(@coupon.send(:can_activate_coupon?)).to be_truthy
    end
  end
end