class Additive < ApplicationRecord
  has_many :products, through: :product_additives
end
