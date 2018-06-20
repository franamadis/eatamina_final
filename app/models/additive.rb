class Additive < ApplicationRecord
  has_many :products, through: :product_additives
  has_many :product_additives
end
