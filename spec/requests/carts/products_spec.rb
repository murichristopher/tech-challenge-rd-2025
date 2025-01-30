require 'rails_helper'

RSpec.describe "/cart", type: :request do
  def json_response
    JSON.parse(response.body)
  end

  let(:product)  { create(:product, name: "Nome do produto X", price: 7.00) }
  let(:product2) { create(:product, name: "Nome do produto Y", price: 9.90) }

  describe "POST /cart/add_item" do
    context "when no cart is in session yet" do
      it "creates a new cart and adds the product with given quantity" do
        post '/cart/add_item', params: { product_id: product.id, quantity: 2 }, as: :json

        expect(response).to have_http_status(:created)
        expect(json_response["id"]).to be_an(Integer)
        expect(json_response["products"]).to eq([
          {
            "id"          => product.id,
            "name"        => "Nome do produto X",
            "quantity"    => 2,
            "unit_price"  => 7.00,
            "total_price" => 14.00
          }
        ])
        expect(json_response["total_price"]).to eq(14.00)
      end
    end

    context "when a cart ALREADY exists in the session" do
      before do
        post '/cart/add_item', params: { product_id: product.id, quantity: 2 }, as: :json
        @existing_cart_id = json_response["id"]
      end

      it "adds a new product to the existing cart" do
        post '/cart/add_item', params: { product_id: product2.id, quantity: 1 }, as: :json

        expect(response).to have_http_status(:created)
        expect(json_response["id"]).to eq(@existing_cart_id)

        expect(json_response["products"]).to contain_exactly(
          {
            "id"          => product.id,
            "name"        => "Nome do produto X",
            "quantity"    => 2,
            "unit_price"  => 7.00,
            "total_price" => 14.00
          },
          {
            "id"          => product2.id,
            "name"        => "Nome do produto Y",
            "quantity"    => 1,
            "unit_price"  => 9.90,
            "total_price" => 9.90
          }
        )
        expect(json_response["total_price"]).to eq(23.90)
      end

      it "updates quantity of an existing product instead of duplicating it" do
        post '/cart/add_item', params: { product_id: product.id, quantity: 1 }, as: :json

        expect(response).to have_http_status(:created)
        expect(json_response["id"]).to eq(@existing_cart_id)

        expect(json_response["products"]).to match([
          {
            "id"          => product.id,
            "name"        => "Nome do produto X",
            "quantity"    => 3,
            "unit_price"  => 7.00,
            "total_price" => 21.00
          }
        ])
        expect(json_response["total_price"]).to eq(21.00)
      end
    end

    context "with invalid parameters" do
      it "returns error if the product does not exist" do
        post '/cart/add_item', params: { product_id: 999, quantity: 2 }, as: :json

        expect(response).to have_http_status(:not_found)
        expect(json_response).to eq(
          "error" => "Produto não encontrado"
        )
      end

      it "returns error for zero quantity" do
        post '/cart/add_item', params: { product_id: product.id, quantity: 0 }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to eq(
          "error" => "A quantidade do produto deve ser maior que zero"
        )
      end

      it "returns error for negative quantity" do
        post '/cart/add_item', params: { product_id: product.id, quantity: -3 }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response).to eq(
          "error" => "A quantidade do produto deve ser maior que zero"
        )
      end
    end
  end
end
