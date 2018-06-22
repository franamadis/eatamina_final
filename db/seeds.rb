
require 'json'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "Destroy old database"
Additive.destroy_all
AdminUser.destroy_all

puts "Old database destroyed"

  filepath = 'services/enumbers.json'

  serialized_enumbers = File.read(filepath)
  enumbers = JSON.parse(serialized_enumbers).flatten
  # flatten to get array
  # array of all hashes with chemicals and its description
  # enumbers[1]

# enumbers[1][1]
# => {"chemical"=>"E100i", "name"=>"Curcumina", "risk"=>"Baja", "description"=>"Colorante natural o sintético. Es de color amarillo brillante al naranja intenso. Tiene sabor amargo. Se obtiene por medio de destilación al vapor, o por extracción con disolventes de la cúrcuma, una raíz de la familia del jengibre procedente de India. A continuación, el extracto se purifica a través de un proceso de cristalización, para así producir polvo de curcumina concentrado.", "effect"=>"Baja"}

  enumbers[1].each do |element|
    chemical = element["chemical"]
    name = element["name"]
    risk = element["risk"]
    description = element["description"]
    effect = element["effect"]
# raise
   additive = Additive.create!(name: name, chemical: chemical, description: description, risk: risk, effect: effect)
  end

puts "Additives created"
AdminUser.create!(email: 'hbs003@hotmail.com', password: 'hbs003', password_confirmation: 'hbs003')
puts "Admin created"
