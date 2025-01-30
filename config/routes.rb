require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products

  resource :cart, controller: "carts", only: %i[show create] do
    post "add_item", to: "carts/products#create"
    # delete "/:product_id", to: "carts/products#destroy", as: :delete_cart_product
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "rails/health#show"
end
