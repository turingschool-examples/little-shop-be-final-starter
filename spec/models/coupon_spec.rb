require 'rails_helper'

RSpec.describe Coupon, type: :model do
  before :each do
    @merchant1 = Merchant.create!(name: "Walmart")
  end

  it { should belong_to(:merchant) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:code) }

  it "validates uniqueness of code" do
    Coupon.create!(name: "Coupon1", code: "Code1", value: 10, active: true, merchant: @merchant1)
    should validate_uniqueness_of(:code) 
  end
  
  it { should validate_numericality_of(:value).is_greater_than(0) }
end