class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :quantity, :unit_price, :total_price

  def id
    object.product.id
  end

  def name
    object.product.name
  end

  def unit_price
    object.product.price.to_f 
  end

  def total_price
    (object.product.price * object.quantity).to_f
  end
end