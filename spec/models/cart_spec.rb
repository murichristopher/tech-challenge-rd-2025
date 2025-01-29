require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  describe '#add_product!' do
    let(:cart) { create(:cart, total_price: 0) }
    let(:product) { create(:product, price: 10.0) }

    context 'when product does not exist in the cart yet' do
      it 'creates a new cart_item with the given quantity' do
        expect { cart.add_product!(product, 2) }
          .to change { cart.cart_items.count }.by(1)

        cart_item = cart.cart_items.last
        expect(cart_item.product).to eq(product)
        expect(cart_item.quantity).to eq(2)
      end

      it 'updates the total_price based on the product price and quantity' do
        cart.add_product!(product, 2)
        expect(cart.total_price).to eq(20.0)  # 2 * 10.0
      end
    end

    context 'when product already exists in the cart' do
      let!(:existing_cart_item) { create(:cart_item, cart: cart, product: product, quantity: 3) }

      it 'increments the quantity of the existing cart_item' do
        cart.add_product!(product, 2)

        existing_cart_item.reload
        expect(existing_cart_item.quantity).to eq(5)  # 3 + 2
      end

      it 'updates the total_price accordingly' do
        cart.add_product!(product, 2)
        expect(cart.total_price).to eq(50.0) # 5 * 10.0
      end
    end

    context 'when an ActiveRecord::RecordInvalid is raised' do
      before do
        allow_any_instance_of(CartItem).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(CartItem.new))
      end

      it 'raises a StandardError with the validation messages' do
        expect {
          cart.add_product!(product, 2)
        }.to raise_error(StandardError, /Failed to add product to the cart: Validation failed/)
      end
    end
  end
end