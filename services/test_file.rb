class generate_seed_db < ApplicationRecord
































require 'open-uri'
require 'nokogiri'
require 'pry'
require 'json'

def secondpage(chemical)
  pages = "http://www.aditivos-alimentarios.com/2016/01/" + chemical + ".html"
  html_file = open(pages).read
  html_doc = Nokogiri::HTML(html_file)

  blocks = html_doc.search('blockquote')
    description = blocks[0].text.strip
    effect = blocks[5].text.strip

  detail_hash = {
    description: description,
    effect: effect
  }
  return detail_hash

# Daves code not hashes of arrays
  # secondpagecontents = { secondpagecontents: [] }
  # descripts = html_doc.search('.post-body blockquote').text
end


def scrapping
  puts "working...."
  puts "😯"
  url = "http://www.aditivos-alimentarios.com/p/lista.html"
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)
  enumbers = { enumbers: []}
  rows = html_doc.search('tbody tr')

  rows.each do |r|

    chemical = r.children[1].text.strip
    p chemical
    name = r.children[3].text.strip
    risk = r.children[5].text.strip
    description = secondpage(chemical)
    enumbers[:enumbers] << {chemical: chemical, name: name, risk: risk, description: description[:description], effect: description[:effect]}
  # binding.pry
  end

  File.open('enumbers.json', 'wb') do |file|
    file.write(JSON.pretty_generate(enumbers))
  end
end

scrapping

end

