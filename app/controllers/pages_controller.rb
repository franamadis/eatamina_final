require 'json'
require 'open-uri'

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home



  def home
    if params[:query].present?
      url = "https://world.openfoodfacts.org/api/v0/product/#{
      params[:query]}.json"
      response_serialized = open(url).read
      response = JSON.parse(response_serialized).flatten
      response2 = response.find {|item| item.class == Hash}

      if response.include?("product found")
        if check_product?
          @new_product = Product.where(sku: params[:query]).first
        else
          @new_product = Product.create!(sku: params[:query], status: "accepted", name: response2['product_name'], photo: response2['image_url'])
        end
        redirect_to product_path(@new_product)
      else
        @new_product = Product.create!(sku: params[:query], status: "pending")
        render new_product_path
      end
    end
  end

  private

  def check_product?
    product = Product.where(sku: params[:query])
    if product != nil
      return true
    else
      return false
    end
  end

end
