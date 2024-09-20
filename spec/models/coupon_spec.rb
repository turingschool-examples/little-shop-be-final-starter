require 'rails_helper'

require 'rails_helper'

RSpec.describe Coupon, type: :model do
  before do
    @merchant = Merchant.create(name: "Test Merchant")
  end

  it { should belong_to(:merchant) }
  it { should have_many(:invoices) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:code) }
  it { should validate_inclusion_of(:active).in_array([true, false]) }

  it 'validates uniqueness of code scoped to merchant_id' do
    Coupon.create!(name: "Existing Coupon", code: "UNIQUECODE", active: true, merchant: @merchant)
    new_coupon = Coupon.new(name: "New Coupon", code: "UNIQUECODE", active: true, merchant: @merchant)
    
    expect(new_coupon).not_to be_valid
    expect(new_coupon.errors[:code]).to include("has already been taken")
  end
end
