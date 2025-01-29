require 'rails_helper'

RSpec.describe Cart::AddProductService, type: :service do
  let(:cart) { create(:cart) }
  let(:product) { create(:product, name: "Nome do produto", price: 1.99) }
  let(:product2) { create(:product, name: "Nome do produto 2", price: 1.99) }

  describe "#call" do
    context "when adding a product successfully" do
      subject { described_class.new(cart: cart, product_id: product.id, quantity: 2) }

      it "adds the product to the cart" do
        expect { subject.call }.to change { cart.cart_items.count }.by(1)
        expect(cart.cart_items.first.product).to eq(product)
        expect(cart.cart_items.first.quantity).to eq(2)
      end

      it "accumulates quantity for the same product" do
        subject.call
        described_class.new(cart: cart, product_id: product.id, quantity: 2).call

        cart.reload

        expect(cart.cart_items.first.quantity).to eq(4)
      end
    end

    context "when adding a second product" do
      it "keeps the same cart but adds a new product" do
        described_class.new(cart: cart, product_id: product.id, quantity: 2).call
        described_class.new(cart: cart, product_id: product2.id, quantity: 2).call

        expect(cart.cart_items.count).to eq(2)
        expect(cart.cart_items.map(&:product)).to contain_exactly(product, product2)
      end
    end

    context "when using an invalid product ID" do
      subject { described_class.new(cart: cart, product_id: 999, quantity: 2) }

      it "raises ProductNotFoundError" do
        expect { subject.call }.to raise_error(Cart::AddProductService::ProductNotFoundError)
      end
    end

    context "when using an invalid quantity" do
      it "raises InvalidQuantityError for zero quantity" do
        service = described_class.new(cart: cart, product_id: product.id, quantity: 0)
        expect { service.call }.to raise_error(Cart::AddProductService::InvalidQuantityError)
      end

      it "raises InvalidQuantityError for negative quantity" do
        service = described_class.new(cart: cart, product_id: product.id, quantity: -1)
        expect { service.call }.to raise_error(Cart::AddProductService::InvalidQuantityError)
      end
    end

    context "when cart update fails" do
      before do
        allow(cart).to receive(:add_product!).and_raise(StandardError)
      end

      it "raises CartUpdateFailedError" do
        service = described_class.new(cart: cart, product_id: product.id, quantity: 2)
        expect { service.call }.to raise_error(Cart::AddProductService::CartUpdateFailedError)
      end
    end
  end
end