require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students_array = []
    html = open(index_url)
    doc = Nokogiri::HTML(html)

    doc.css(".student-card").each { |student|
      name = student.css(".student-name").text
      location = student.css(".student-location").text
      profile_url = student.css("a").attribute("href").value
      students_array << { name: name, location: location, profile_url: profile_url }
    }
    students_array
  end

  def self.scrape_profile_page(profile_url)
    profile_hash = {}
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    social = doc.css(".social-icon-container").css("a").map { |link| link.attribute("href").value }

    social.each { |link|
      #binding.pry
      if link.include?("twitter")
        profile_hash[:twitter] = link
      elsif link.include?("linkedin")
        profile_hash[:linkedin] = link
      elsif link.include?("github")
        profile_hash[:github] = link
      else
        profile_hash[:blog] = link
      end
    }

    profile_quote = doc.css(".profile-quote").text
    profile_hash[:profile_quote] = profile_quote if profile_quote

    bio = doc.css(".description-holder p").text
    profile_hash[:bio] = bio if bio

    profile_hash
  end

end
#Scraper.scrape_profile_page("./fixtures/student-site/students/joe-burgess.html")
