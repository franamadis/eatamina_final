
require 'open-uri'
require 'nokogiri'
require 'pry'
require 'json'

def getdescription(chemical)
  pages = "http://www.aditivos-alimentarios.com/2016/01/" + chemical + ".html"
  html_file = open(pages).read
  html_doc = Nokogiri::HTML(html_file)
  blocks = html_doc.search('blockquote')
  description = blocks[0].text.strip
end

def geteffect(chemical)
  pages = "http://www.aditivos-alimentarios.com/2016/01/" + chemical + ".html"
  html_file = open(pages).read
  html_doc = Nokogiri::HTML(html_file)
  titles = html_doc.search('.titles')
  effect = ""
  titles.each do |a|
    p a.text
    if a.text.include?('secundarios')
      effect = a.text.gsub(/\n/, "")
    end
  end
  return effect
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

    name = r.children[3].text.strip

    risk = r.children[5].text.strip

    description = getdescription(chemical)

    effect = geteffect(chemical)

    enumbers[:enumbers] << {chemical: chemical, name: name, risk: risk, description: description, effect: effect}

  end

  File.open('enumbers.json', 'wb') do |file|
    file.write(JSON.pretty_generate(enumbers))
  end
end

scrapping
