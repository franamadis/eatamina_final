class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :show, :update, :edit]
  # before_action :check_if_admin, only: [:edit, :update, :destroy]

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.status = "pending"
    if @product.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
      # authorize @product
      # redirect_to dashboard_requests_path
    @product = Product.find(params[:id])
    # @requests = Product.requests
  end

  def update

    @product = Product.find(params[:id])
    @product.update(product_params)
    if @product.save
      redirect_to product_path(@product)
    else
      redirect_to root_path
    end
  end

  # def destroy
  #   # authorize @product
  #   @product = Product.find(params[:id])
  #   if @product.destroy
  #     redirect_to root_path
  #   else
  #     redirect_to root_path
  #   end
  # end

  private

  # def requests
  #   @requests = Product.requests
  # end

  # def check_if_admin
  #   if not current_user.admin
  #     redirect_to root_path
  #   end
  # end

  def product_params
    params.require(:product).permit(:name, :sku, :photo, :status, :response, :nutritional_info, :prod_add, :brand, :nutrition_grade)
  end
end
