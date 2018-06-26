class Product < ApplicationRecord
  has_many :product_additives
  has_many :additives, through: :product_additives
  has_many :users, through: :queries
  has_many :queries
  acts_as_votable


  def self.requests
    Product.where(status: 'pending')
  end

  def presentable_grade
    case nutrition_grade.upcase
    when "A"
      return 90
    when "B"
      return 70
    when "C"
      return 50
    when "D"
      return 30
    when "E"
      return 10
    else
      return "No grade!"
    end
  end
end
