FactoryBot.define do
    factory :coupon do
      name { "Coupon Name" }  
      code { "BOGO50" } 
      percent_off { 50.0 } 
      dollar_off { nil }  
      used_count { 0 }  
  
      association :merchant

    end
  end
  