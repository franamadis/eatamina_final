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
<<<<<<< HEAD
  
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
=======

# update already created product from our DB with its SKU, status and response


# NEED IF ELSE STATMENT when is displaying page to create new product but ON WORDFOODFACTS is not this product under SKU at all

# IT GIVE US error IN TERMINAL rails c
  # NoMethodError: undefined method `[]' for nil:NilClass
  # from /Users/illyshelly/code/eatamina/eatamina_final/app/models/product.rb:97:in `sync'

# if response.include?("product found")

  def sync
    # pending = Product.where(status: 'pending')

    #   if pending != nil
    #     # array with all ids where pending products
    #       prod_ids << pending.ids
    #       prod_ids.each do |id|
    #         pending_object = pending.find(id)
    #         ask_sku = pending_object[:sku].to_i
    #     end
    #   end

    # sku = 20764081
    url = "https://world.openfoodfacts.org/api/v0/product/#{self[:sku]}.json"
    response_serialized = open(url).read
    response = JSON.parse(response_serialized).flatten

  # if response.include?("product found")
    response2 = response.find {|item| item.class == Hash}

      self[:name] = response2['product_name']
      self[:photo] = response2['image_url']
      self[:nutritional_info] = response2['nutriments']
      self[:prod_add] = response2['additives_tags']
      self[:brand] = response2['brands']
      self[:nutrition_grade] = response2['nutrition_grades']
      # update status if product has at least 4 parameters
        if self[:name] && self[:photo] && self[:brand] && self[:nutritional_info]
          self[:status] = "accepted"
        else
          self[:status] = "pending"
        end
        # check if product is in category organic
        if organic_check(response2)
          self[:organic] = true
        else
          self[:organic] = false
        end
        self.save
    # end
  end

  private

  def organic_check(response2)
     if response2 != nil
        if (response2["labels"] != nil)
          if (response2["labels"].include? "organic")
            organic = true
          else
            organic = false
          end
        end

        if (response2["labels_hierarchy"] != nil) && (organic == false)
          if (response2["labels_hierarchy"].include? "en:organic")
            organic = true
          else
            organic = false
          end
        end
      end
  end

>>>>>>> 163260b3d138ced564ead3cd437b3fab7b756a2a
end
