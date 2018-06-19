class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: :new, :show
  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.status = "pending"
    if @product.save
      redirect_to root_path
    else
      :new
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    authorize @product
    @product = Product.find(params[:id])
  end

  def update
    authorize @product
    @product = Product.find(params[:id])
    @product.update(product_params)
    if @product.save
      redirect_to product_path(@product)
    else
      render :edit
    end
  end

  def destroy
    authorize @product
    @product = Product.find(params[:id])
    if @product.destroy
      redirect_to root_path
    else
      render:edit
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :sku, :photo)
  end
end
