class AdditivesController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  def show
    @additives = Additive.find(params[:id])
  end
end
