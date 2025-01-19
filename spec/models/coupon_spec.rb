# bundle exec rspec spec/models/coupon_spec.rb

require 'rails_helper'

RSpec.describe Coupon, type: :model do
  let(:merchant) { create(:merchant) }

  describe 'relationships' do
    it { should belong_to :merchant } 
    it { should have_many :coupon_uses } 
  end

  describe 'validations' do
    context 'when neither percent_off nor dollar_off is provided' do
      it 'provides an error message' do
        coupon = Coupon.new(merchant: merchant, name: 'Test Coupon', code: 'TESTCODE')
        coupon.valid?  
        expect(coupon.errors[:base]).to include('You must provide either percent_off or dollar_off.')
      end
    end

    context 'when both percent_off and dollar_off are provided' do
      it 'provides an error message' do
        coupon = Coupon.new(
          merchant: merchant,
          name: 'Test Coupon',
          code: 'TESTCODE',
          percent_off: 10,
          dollar_off: 5
        )
        coupon.valid?  
        expect(coupon.errors[:base]).to include('You must provide either percent_off or dollar_off.')
      end
    end

    context 'when only percent_off is provided' do
      it 'does not add an error to base' do
        coupon = Coupon.new(
          merchant: merchant,
          name: 'Test Coupon',
          code: 'TESTCODE',
          percent_off: 10
        )
        expect(coupon).to be_valid
      end
    end

    context 'when only dollar_off is provided' do
      it 'does not add an error to base' do
        coupon = Coupon.new(
          merchant: merchant,
          name: 'Test Coupon',
          code: 'TESTCODE',
          dollar_off: 5
        )
        expect(coupon).to be_valid
      end
    end
  end

  describe 'instance methods' do
    before do
      @merchant = create(:merchant)
      @coupon1 = create(:coupon, merchant: @merchant)
      @customer1 = create(:customer)
    end
  
    it '#used_count tracks the number of coupon uses for each coupon' do
      expect(@coupon1.used_count).to eq(0)

      create_list(:coupon_use, 3, coupon: @coupon1, customer: @customer1)

      expect(@coupon1.used_count).to eq(3)
    end

    it '#deactivate! can deactivate a coupon' do
      expect(@coupon1.status).to eq("active")  
      
      @coupon1.deactivate!

      expect(@coupon1.status).to eq("inactive")
    end

    it '#activate! can activate a coupon' do 
      @coupon1.activate!
      
      expect(@coupon1.status).to eq("active")
    end
  end
end
