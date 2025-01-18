require "rails_helper"

RSpec.describe Invoice do
  it { should belong_to :merchant }
  it { should belong_to :customer }
  it { should validate_inclusion_of(:status).in_array(%w(shipped packaged returned)) }

#   describe 'coupon associations' do
# #     it { should belong_to(:coupon).optional }
#       end
#     end

end