require 'rails_helper'

describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_numericality_of(:unit_price) }
  end

  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items).dependent(:destroy) }
  end

  describe "class methods" do
    it "should sort items by price, cheapest to most expensive" do
      middle = create(:item, unit_price: 145)
      cheap = create(:item, unit_price: 100)
      expensive = create(:item, unit_price: 1000)

      expect(Item.sort_by_price).to eq([cheap, middle, expensive])
    end

    it "should sort items by price, handling same price items" do
      cheap1 = create(:item, unit_price: 100)
      cheap2 = create(:item, unit_price: 100)
      expensive = create(:item, unit_price: 1000)

      expect(Item.sort_by_price).to eq([cheap1, cheap2, expensive])
    end
  end

  describe "search functions" do
    let(:merchant) { create(:merchant) }

    it "should find items by name" do
      item1 = create(:item, name: "Apple of my eye", merchant: merchant)
      create(:item, name: "pineapple", merchant: merchant)
      create(:item, name: "Golden delicious apple", merchant: merchant)

      item_found = Item.find_one_item_by_name("APPLE")
      expect(item_found.id).to eq(item1.id)
      expect(Item.find_all_by_name("aPpLe").count).to eq(3)
    end

    it "should return the one item that satisfies the price query, ordering by name if necessary" do
      item1 = create(:item, name: "grapes", unit_price: 4.99, merchant: merchant)
      item2 = create(:item, name: "oreos", unit_price: 1.05, merchant: merchant)
      item3 = create(:item, name: "bananas", unit_price: 15.50, merchant: merchant)

      expect(Item.find_one_item_by_price(max_price: 5).name).to eq("grapes") 
      expect(Item.find_one_item_by_price(min_price: 1.0, max_price: 2).name).to eq("oreos")
      expect(Item.find_one_item_by_price(min_price: 10).name).to eq("bananas")
    end

    it "should return all items that satisfy price query" do
      item1 = create(:item, name: "grapes", unit_price: 4.99, merchant: merchant)
      item2 = create(:item, name: "oreos", unit_price: 1.05, merchant: merchant)
      item3 = create(:item, name: "bananas", unit_price: 15.50, merchant: merchant)

      expect(Item.find_items_by_price(max_price: 5)).to eq([item1, item2])
      expect(Item.find_items_by_price(min_price: 0, max_price: 25)).to eq([item3, item1, item2])
    end

    it "should return no items when price query has no results" do
      item1 = create(:item, name: "grapes", unit_price: 4.99, merchant: merchant)
      create(:item, name: "oreos", unit_price: 1.05, merchant: merchant)

      expect(Item.find_items_by_price(min_price: 50)).to eq([])
      expect(Item.find_items_by_price(min_price: 1000)).to eq([])
    end

    it "should return no items when no name matches" do
      create(:item, name: "grapes", merchant: merchant)
      create(:item, name: "oreos", merchant: merchant)

      expect(Item.find_one_item_by_name("nonexistent")).to be_nil
      expect(Item.find_all_by_name("nonexistent")).to eq([])
    end
  end
end