require 'json'
require 'open-uri'

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home



  def home
    if params[:query].present?
      @product = {}
      @product[:sku] = params[:query]
      url = "https://world.openfoodfacts.org/api/v0/product/#{@product[:sku]}.json"
      response_serialized = open(url).read
      response = JSON.parse(response_serialized).flatten(100)
      if response['status_verbose'] == "product found"
        new_product = Product.create(sku: params[:query], status: "accepeted", name: response['product_name'], photo:response['image_url']  )
        redirect_to product_path(new_product)
      else
        new_product = Product.create(sku:params[:query])
        redirect_to new_product_path(new_product)
      end
    end
  end

end
