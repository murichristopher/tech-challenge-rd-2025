require 'rails_helper'

RSpec.describe "/cart", type: :request do
  def json_response
    JSON.parse(response.body)
  end

  let(:product) { create(:product, name: "Nome do produto", price: 1.99) }
  let(:product2) { create(:product, name: "Nome do produto 2", price: 1.99) }

  describe "POST /cart" do
    context "when adding products" do
      subject do
        post '/cart', params: { product_id: product.id, quantity: 2 }, as: :json
      end

      it "creates a new cart and adds the product" do
        expect { subject }.to change(Cart, :count).by(1)
        expect(response).to have_http_status(:created)

        expect(json_response).to match(
          "id" => be_an(Integer),
          "products" => [
            {
              "id" => product.id,
              "name" => "Nome do produto",
              "quantity" => 2,
              "unit_price" => 1.99,
              "total_price" => 3.98
            }
          ],
          "total_price" => 3.98
        )
      end

      it "reuses the cart from session" do
        subject
        first_cart_id = json_response["id"]

        post '/cart', params: { product_id: product2.id, quantity: 2 }, as: :json
        second_cart_id = json_response["id"]

        expect(second_cart_id).to eq(first_cart_id)

        expect(json_response).to match(
          "id" => first_cart_id,
          "products" => contain_exactly(
            {
              "id" => product.id,
              "name" => "Nome do produto",
              "quantity" => 2,
              "unit_price" => 1.99,
              "total_price" => 3.98
            },
            {
              "id" => product2.id,
              "name" => "Nome do produto 2",
              "quantity" => 2,
              "unit_price" => 1.99,
              "total_price" => 3.98
            }
          ),
          "total_price" => 7.96
        )
      end

      it "accumulates quantity for the same product" do
        subject
        post '/cart', params: { product_id: product.id, quantity: 2 }, as: :json

        expect(response).to have_http_status(:created)

        expect(json_response).to match(
          "id" => be_an(Integer),
          "products" => [
            {
              "id" => product.id,
              "name" => "Nome do produto",
              "quantity" => 4,
              "unit_price" => 1.99,
              "total_price" => 7.96
            }
          ],
          "total_price" => 7.96
        )
      end
    end

    context "with invalid parameters" do
      it "returns error for non-existent product" do
        post '/cart', params: { product_id: 999, quantity: 2 }, as: :json

        expect(response).to have_http_status(:not_found)
        expect(json_response).to match(
          "error" => "Produto não encontrado"
        )
      end

      it "returns error for invalid quantity (zero)" do
        post '/cart', params: { product_id: product.id, quantity: 0 }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to match(
          "error" => "A quantidade do produto deve ser maior que zero"
        )
      end

      it "returns error for invalid quantity (negative)" do
        post '/cart', params: { product_id: product.id, quantity: -1 }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to match(
          "error" => "A quantidade do produto deve ser maior que zero"
        )
      end
    end
  end
end