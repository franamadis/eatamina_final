class Product < ApplicationRecord
  has_many :product_additives;
  has_many :product_queries;
end
