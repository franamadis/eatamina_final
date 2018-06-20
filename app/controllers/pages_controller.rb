require 'json'
require 'open-uri'

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home



  def home
    if params[:query].present?
      # @product = {}
      # @product[:sku] = params[:query]
      url = "https://world.openfoodfacts.org/api/v0/product/#{
      params[:query]}.json"
      response_serialized = open(url).read
      response = JSON.parse(response_serialized).flatten
      response2 = response.find {|item| item.class == Hash}

      if response.include?("product found")
        @new_product = Product.create!(sku: params[:query], status: "accepted", name: response2['product_name'], photo: response2['image_url'])
        redirect_to product_path(@new_product)
      else
        @new_product = Product.create(sku:params[:query])
        redirect_to new_product_path(@new_product)
      end
    end
  end

end
