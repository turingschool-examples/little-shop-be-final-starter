require "rails_helper"

RSpec.describe Invoice do
  describe 'associations' do
    it { should belong_to :merchant }
    it { should belong_to :customer }
  end

  describe 'optional associations' do
    let(:merchant) { create(:merchant) }
    let(:customer) { create(:customer) }
    let(:active_coupon) { create(:coupon, active: true)}
    it 'is valid with an active coupon' do
      invoice = build(:invoice, :with_coupon, customer: customer, merchant: merchant, coupon: active_coupon)
      expect(invoice).to be_valid
    end
      
    it 'is valid without a coupon' do
      invoice = build(:invoice, customer: customer, merchant: merchant)
      expect(invoice).to be_valid
    end
  end

  describe 'validations' do
    it { should validate_inclusion_of(:status).in_array(%w(shipped packaged returned)) }
  end

  describe 'coupon must be active instance method' do
    let(:merchant) { create(:merchant) }
    let(:customer) { create(:customer) }
    let(:inactive_coupon) { create(:coupon, active: false)}
    it 'is invalied if coupon is inactive' do
      # invoice = build(:invoice, customer: customer, merchant: merchant, coupon: inactive_coupon)
      invoice = build(:invoice, :with_coupon, coupon: inactive_coupon)
      # invoice = create(:invoice, customer: customer, merchant: merchant, coupon: coupon, status: "shipped")
      expect(invoice).to_not be_valid
      expect(invoice.errors[:coupon]).to include("must be active.")

    
    end
  end

end