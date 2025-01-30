class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  def add_product!(product, quantity)
    transaction do
      item = cart_items.find_or_initialize_by(product: product)
      item.quantity = item.persisted? ? item.quantity + quantity : quantity
      item.save!
      update_total_price!
      item
    end
  rescue => e
    raise StandardError, "Failed to add product to the cart: #{e.message}"
  end

  def delete_product(product_id)
    item = cart_items.find_by(product_id: product_id)
    return false unless item

    item.destroy
    update_total_price!
    true
  end

  private

  def update_total_price!
    self.total_price = cart_items.sum { |item| item.quantity * item.product.price }
    save!
  end
end
