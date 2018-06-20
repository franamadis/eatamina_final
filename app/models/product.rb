class Product < ApplicationRecord

  has_many :additives, through: :product_additives
  has_many :users, through: :queries


  def self.requests
    Product.where(status: 'pending')
  end

end
