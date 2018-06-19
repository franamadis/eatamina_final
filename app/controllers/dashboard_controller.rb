class DashboardController < ApplicationController
  def create_requests
    @requests = Product.requests
  end
end
