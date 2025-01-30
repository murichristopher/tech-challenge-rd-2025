class Cart::AddProductService
  class InvalidQuantityError < StandardError; end
  class ProductNotFoundError < StandardError; end
  class CartUpdateFailedError < StandardError; end

  attr_reader :errors

  def initialize(cart:, product_id:, quantity:)
    @cart = cart
    @product_id = product_id
    @quantity = quantity
  end

  def call
    validate_quantity!
    product = find_product!
    add_to_cart!(product)

    true
  end

  private

  def validate_quantity!
    raise InvalidQuantityError unless @quantity.positive?
  end

  def find_product!
    Product.find_by(id: @product_id).tap do |product|
      raise ProductNotFoundError unless product
    end
  end

  def add_to_cart!(product)
    @cart.add_product!(product, @quantity)
  rescue StandardError => e
    raise CartUpdateFailedError
  end
end