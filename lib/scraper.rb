require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    arr = []
    html = open(index_url)
    doc = Nokogiri::HTML(html)
     arr = doc.css(".roster-cards-container").css("a .card-text-container .student-name")
     arr2 = doc.css(".roster-cards-container").css("a .card-text-container .student-location")

     i = 0
     getarr = []
     while i < arr.length
       name = arr[i].text.split(" ")
        name[0] = name[0].downcase
        name[1] =  name[1].to_s.downcase

       url = "students/" + name.join("-") + ".html"
       obj = {:name => arr[i].text, :location => arr2[i].text, :profile_url=>url}
       getarr << obj
       i += 1
     end
      getarr
  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    arr = doc.css(".vitals-container .social-icon-container a")
    obj = {}
    arr.each do |element|
      if element.attribute("href").value.include?("twitter")
        obj[:twitter] = element.attribute("href").value
      elsif element.attribute("href").value.include?("linkedin")
        obj[:linkedin] = element.attribute("href").value
      elsif element.attribute("href").value.include?("github")
        obj[:github] = element.attribute("href").value
      elsif element.attribute("href").value.include?("blog")
        obj[:blog] = element.attribute("href").value
      elsif element.attribute("href").value.include?("bio")
        obj[:bio] = element.attribute("href").value
      else
        obj[:profile_quote] = element.attribute("href").value

      end
    end
     obj
  end
end
