require 'rails_helper'

RSpec.describe Coupon, type: :model do
  before(:each) do 
    @merchant = Merchant.create!(name: "Sample Merchant")
  end 
  describe 'relationships' do 
    it {should belong_to(:merchant)}
    it {should have_many(:invoices)}
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code).scoped_to(:merchant_id) } # Scope to merchant_id if needed
    it { should validate_inclusion_of(:active).in_array([true, false]) }
  end
end
