require "rails_helper"

RSpec.describe CartsController, type: :routing do
  describe 'routes' do
    it 'routes to #show' do
      expect(get: '/cart').to route_to('carts#show')
    end

    it 'routes to #create' do
      expect(post: '/cart').to route_to('carts#create')
    end

    it 'routes to #add_item via POST' do
      expect(post: '/cart/add_item').to route_to('carts/products#create')
    end

    it 'routes to #destroy for a product in the cart via DELETE' do
      expect(delete: '/cart/1').to route_to('carts/products#destroy', product_id: '1')
    end
  end
end