class Carts::ProductsController < CartsController
  def create
    Cart::AddProductService.new(
      cart: @cart,
      product_id: params[:product_id],
      quantity: params[:quantity].to_i
    ).call

    render json: @cart, status: :created
  rescue Cart::AddProductService::InvalidQuantityError
    render_error('A quantidade do produto deve ser maior que zero', :unprocessable_entity)
  rescue Cart::AddProductService::ProductNotFoundError
    render_error('Produto não encontrado', :not_found)
  rescue Cart::AddProductService::CartUpdateFailedError
    render_error('Falha ao adicionar o produto ao carrinho', :unprocessable_entity)
  end

  def destroy
    product = Product.find(params[:product_id])

    if @cart.delete_product(product.id)
      render json: @cart, status: :ok
    else
      render_error('Produto não encontrado no carrinho', :not_found)
    end
  rescue ActiveRecord::RecordNotFound
    render_error('Produto não encontrado', :not_found)
  end
end