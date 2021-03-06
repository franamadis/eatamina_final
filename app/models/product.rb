require 'json'
require 'open-uri'

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

  def organic_grade
    case organic
    when true
      return 10
    when false
      return 0
    end
  end

  def additive_grade
    risk_grade = 0
    if self.prod_add != nil
      JSON[self.prod_add].each do |additive|
        additive_adj = additive[3..6].capitalize
        if Additive.find_by_chemical(additive_adj) == nil
          risk_grade = risk_grade
        else
          risk = Additive.find_by_chemical(additive_adj).risk
          case risk
          when "Alta"
            risk_grade = risk_grade + 10
          when "Media"
            risk_grade = risk_grade + 5
          end
        end
      end
    end
    return risk_grade
  end

  def final_score
    if self.nutrition_grade?
      score = self.presentable_grade + self.organic_grade
      if self.additive_grade <= 30
        score = score - self.additive_grade
      else
        score = score - 30
      end
      if score <0
        score = 0
      end

    end
    return score
  end
  
  def valor_nutricional(x)
    nutritional = eval(self.nutritional_info)
     if self.nutritional_info? && nutritional[x] != nil
        nutritional[x].to_d.truncate(2).to_f
     else
      return 0
    end 
  end


  def sync
    url = "https://world.openfoodfacts.org/api/v0/product/#{self[:sku]}.json"
    response_serialized = open(url).read
    response = JSON.parse(response_serialized).flatten
    puts "response"
    puts response
    response2 = response.find {|item| item.class == Hash}
    puts "response2"
    puts response2
    self[:nutritional_info] = response2['nutriments']
    self.save
  end
end
