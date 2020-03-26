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
      if arr.attribute("href").value.include?("twitter")
        obj[:twitter] = arr.attribute("href").value
      elsif arr.attribute("href").value.include?("linkedin")
        obj[:linkedin] = arr.attribute("href").value
      elsif social.attribute("href").value.include?("github")
        obj[:github] = arr.attribute("href").value
      else
        obj[:blog] = arr.attribute("href").value
      end
    end
  end
end


  Scraper.scrape_profile_page("https://learn-co-curriculum.github.io/student-scraper-test-page/students/ryan-johnson.html")
