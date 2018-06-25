class QueriesController < ApplicationController
  def index
    @queries = current_user.queries
  end
end
