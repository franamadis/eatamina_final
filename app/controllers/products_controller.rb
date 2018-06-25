class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :show, :update, :edit]
  # before_action :check_if_admin, only: [:edit, :update, :destroy]
  def index
    @liked_products = current_user.get_up_voted(Product)
  end

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
    if @product.prod_add != nil
      JSON[@product.prod_add].each do |additive|
        additive_adj = additive[3..6].capitalize
        if Additive.find_by_chemical(additive_adj) == nil
          @risk = nil
        else
          @risk = Additive.find_by_chemical(additive_adj).risk
        end
      end
    end
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

  def upvote
    @product = Product.find(params[:id])
    @product.upvote_by current_user
    render :show
  end

  def downvote
    @product = Product.find(params[:id])
    @product.downvote_by current_user
    render :show
  end


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
