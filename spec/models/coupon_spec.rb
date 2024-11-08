require 'rails_helper'

RSpec.describe Coupon, type: :model do
  it { should belong_to(:merchant) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:code) }
  it { should validate_uniqueness_of(:code) }
end