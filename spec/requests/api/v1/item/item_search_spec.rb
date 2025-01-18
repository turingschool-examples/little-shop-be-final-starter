require "rails_helper"

RSpec.describe "Item Search Endpoints" do
  context "find one item:" do
    describe "happy path" do
      let(:merchant) { create(:merchant) }
      it "should retrieve the first item alphabetically" do
        item1 = merchant.items.create({name: "brush", description: "good stuff", unit_price: 13.50})
        item2 = merchant.items.create({name: "No more rush Watch", description: "You will never rush again",
                            unit_price: 25.50})

        get api_v1_items_find_index_path, params: {name: "rush"}
        json = JSON.parse(response.body, symbolize_names: true)
        
        expect(json[:data][:attributes][:name]).to eq("brush")
      end

      it "should return the item that satisfies price queries" do
        item1 = create(:item, name: "apple", unit_price: 1.09, merchant: merchant)
        item2 = create(:item, name: "banana", unit_price: 0.99, merchant: merchant)
        item3 = create(:item, name: "mango", unit_price: 3.99, merchant: merchant)

        get api_v1_items_find_index_path, params: { min_price: 0, max_price: 3}
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data][:attributes][:name]).to eq("apple")
      end

      it "should return an empty object if item is not present" do
        item1 = merchant.items.create({name: "brush", description: "good stuff", unit_price: 13.50})
        item2 = merchant.items.create({name: "No more rush Watch", description: "You will never rush again", unit_price: 25.50})

        get api_v1_items_find_index_path, params: {name: "dog"}
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:data]).to eq({ })
      end
    end

    describe "sad path" do
      it "should return an error if there are no search params" do
        get api_v1_items_find_index_path
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:errors][0]).to eq("Invalid search parameters provided")
      end

      it "should return an error if name and price params are present" do
        get api_v1_items_find_index_path, params: { name: "ring", max_price: 3}
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:errors][0]).to eq("Invalid search parameters provided")

        get api_v1_items_find_index_path, params: { name: "ring", min_price: 0, max_price: 3}
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:errors][0]).to eq("Invalid search parameters provided")
      end

      it "should return an error if price params are negative" do
        get api_v1_items_find_index_path, params: { max_price: -3}
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:errors][0]).to eq("Invalid search parameters provided")
      end

      it "should return an error if any params are empty strings" do
        get api_v1_items_find_index_path, params: { name: "" }
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:errors][0]).to eq("Invalid search parameters provided")
      end
    end
  end

  context "find all items:" do
    let(:merchant) { create(:merchant) }

    it "should return all items that verify the price parameters" do
      item1 = create(:item, name: "apple", unit_price: 1.09, merchant: merchant)
      item2 = create(:item, name: "banana", unit_price: 0.99, merchant: merchant)
      item3 = create(:item, name: "mango", unit_price: 3.99, merchant: merchant)


      get api_v1_items_find_all_index_path, params: { max_price: 3.50 }
      json = JSON.parse(response.body, symbolize_names: true)

      item_names = json[:data].map { |element| element[:attributes][:name] }
      expect(item_names).to match_array(["apple", "banana"])

    end
  end
end