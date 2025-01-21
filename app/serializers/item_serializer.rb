class ItemSerializer
  include JSONAPI::Serializer
  attributes :name, :description, :merchant_id

  attribute :unit_price do |object|
    object.unit_price.to_f # Ensure it returns as a float
  end
end
