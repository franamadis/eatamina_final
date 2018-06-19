class DashboardController < ApplicationController
  before_action :check_if_admin

  def index
    @requests = Product.requests
  end

  private

  def check_if_admin
    if not current_user.admin
      redirect_to root_path
    end
  end
end
