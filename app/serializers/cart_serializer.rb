class CartSerializer < ActiveModel::Serializer
  attributes :id, :total_price

  has_many :cart_items, key: :products

  def total_price
    object.total_price.to_f
  end
end