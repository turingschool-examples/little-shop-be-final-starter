require 'rails_helper'

RSpec.describe Coupon, type: :model do
  describe 'associations' do
    it {should belong_to(:merchant)}
    it {should have_many(:invoices)}
  end

  describe 'validations' do
    subject { FactoryBot.create(:coupon)}

    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:code)}
    it {should validate_uniqueness_of(:code)}
    it {should validate_presence_of(:discount_value)}
    it {should validate_inclusion_of(:discount_type).in_array(['percent', 'dollar'])}
  end
end