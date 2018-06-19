class Product < ApplicationRecord
  has_many :product_additives;
  has_many :queries;
  validates :name, uniqueness: true, presence: true
  validates :sku, uniqueness: true, presence: true
  mount_uploader :photo, PhotoUploader
  # def requests
  #   products.map { |product| product.status == "pending" }.flatten
  # end

  # Product.requests
  # scope :requests, -> {where(status: 'pending')}
  #before the best way to right the method, means the same
  def self.requests
    Product.where(status: 'pending')
  end

end
