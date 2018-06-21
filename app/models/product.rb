class Product < ApplicationRecord
  has_many :product_additives
  has_many :additives, through: :product_additives
  has_many :users, through: :queries
  has_many :queries


  def self.requests
    Product.where(status: 'pending')
  end

end
