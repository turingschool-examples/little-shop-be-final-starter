require "rails_helper"

RSpec.describe Coupon do
  describe 'associations' do
    it { should belong_to :merchant }
  end

  describe "required presence attribute validations" do
    it { should validate_presence_of :full_name }
    it { should validate_presence_of :code }
    it { should validate_presence_of :merchant_id }
    it { should validate_presence_of :usage_count }
  end

  describe "specific attribute validations" do
    let(:merchant) { create(:merchant) }
    it "is valid when all attributes are present and valid" do
      coupon = create(:coupon, merchant: merchant, percent_off: 15.0, dollar_off: nil)
       
      expect(coupon).to be_valid
      expect(coupon.persisted?).to be true
    end

    it "is invalid if the code is not unique" do
      coupon1 = create(:coupon, merchant: merchant, code: "UNIQUECODE")
      coupon2 = build(:coupon, merchant: merchant, code: "UNIQUECODE")

      expect(coupon2).to_not be_valid
      expect(coupon2.errors[:code]).to include("has already been taken")
    end

    it "is valid when active is true" do 
      coupon = create(:coupon, merchant: merchant, active: true)
       
      expect(coupon).to be_valid
    end
    
    it "is valid when active is false" do
      coupon = create(:coupon, merchant: merchant, active: false)
       
      expect(coupon).to be_valid
    end

    it "is invalid when active is nil" do
      coupon = build(:coupon, merchant: merchant, active: nil)
       
      expect(coupon).to_not be_valid
      expect(coupon.errors[:active]).to include("is not included in the list")
    end
  end

  describe "Instance variables" do
    describe "#discount_type_constraints determines a coupon" do
      let(:merchant) { create(:merchant) }
      it "a coupon is valid when percent_off is not nill and dollar_off is nil" do
        coupon = build(:coupon, merchant: merchant, active: true, percent_off: 10, dollar_off: nil)
        
        expect(coupon).to be_valid
      end

      it "a coupon is valid when dollar_off is not nill and percent_off is nil" do
        coupon = build(:coupon, merchant: merchant, active: true, percent_off: nil, dollar_off: 10)
        
        expect(coupon).to be_valid
      end

      it "a coupon is invalid when both dollar_off and percent_off are nil" do
        coupon = build(:coupon, merchant: merchant, active: true, percent_off: nil, dollar_off: nil)
    
        expect(coupon).to_not be_valid
        expect(coupon.errors[:discount_type_error,]).to include("one discount type (percent or dollar off) must be specified.")
      end

      it "a coupon is invalid when both dollar_off and percent_off have a value" do
        coupon = build(:coupon, merchant: merchant, active: true, percent_off: 10, dollar_off: 12)
    
        expect(coupon).to_not be_valid 
        expect(coupon.errors[:discount_type_error]).to include("only one discount type (percent or dollar off) can be specified at a time.")
      end
    end

    describe "#merchant_coupon_limit_to_five" do
      let(:merchant) { create(:merchant) }
      it "does NOT allow more than 5 active coupons for a merchant" do
        create_list(:coupon, 5, merchant: merchant, active: true)
        new_coupon = build(:coupon, merchant: merchant, active: true)
     
        expect(new_coupon).to_not be_valid
        expect(new_coupon.errors[:coupon_limit_error]).to include("This merchant already has 5 active coupons.")
      end
    end
  end
end

 