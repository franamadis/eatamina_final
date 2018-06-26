require 'json'
require 'open-uri'

class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  after_action :set_query, only: :home



  def home
    if params[:query].present?
      url = "https://world.openfoodfacts.org/api/v0/product/#{
      params[:query]}.json"
      response_serialized = open(url).read
      response = JSON.parse(response_serialized).flatten
      response2 = response.find {|item| item.class == Hash}
      if response2 != nil
         organic = response2["labels"].include? "organic"
      else
         organic = false
      end



      if response.include?("product found") && response2['nutrition_grades'] != nil
        if check_product?
          @new_product = Product.where(sku: params[:query]).first
        else
          # @new_product = Product.create!(sku: params[:query], status: "accepted", response: response, name: response2['product_name'], photo: response2['image_url'], nutritional_info: response2['nutriments'], prod_add: response2['additives_tags'], brand: response2['brands'], nutrition_grade: response2['nutrition_grades'] ) ---- response including all the jason
          @new_product = Product.create!(sku: params[:query], status: "accepted", name: response2['product_name'], photo: response2['image_url'], nutritional_info: response2['nutriments'], prod_add: response2['additives_tags'], brand: response2['brands'], nutrition_grade: response2['nutrition_grades'], organic: organic )
        end
        redirect_to product_path(@new_product)
      elsif response.include?("product found")
        if check_product?
          @new_product = Product.where(sku: params[:query]).first
        else
          @new_product = Product.create!(sku: params[:query], status: "pending", name: response2['product_name'], photo: response2['image_url'], nutritional_info: response2['nutriments'], prod_add: response2['additives_tags'], brand: response2['brands'], nutrition_grade: response2['nutrition_grades'], organic: organic, )
        end
        redirect_to products_message_path
      else
        @new_product = Product.create!(sku: params[:query], status: "pending", response: "product found")
        session[:new_product] = @new_product
        redirect_to products_message_path
      end
    end
  end

  private

  def check_product?
    product = Product.where(sku: params[:query])
    if product.length != 0
      return true
    else
      return false
    end
  end

  def set_query
    if params[:query].present? && current_user && current_user.queries.find_by(product_id: @new_product.id).nil?
      Query.create(user: current_user, product: @new_product)
    # else
    #   session[:latest_query_product_id] = @new_product.id
    end
  end

end
