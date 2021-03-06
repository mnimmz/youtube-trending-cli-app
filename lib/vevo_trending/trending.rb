# Stopped video at 36:42
require 'open-uri'
require 'uri'

class VevoTrending::Trending
  attr_accessor :title, :name, :url, :likes, :views, :director
  def self.today
    # Scrape YouTube Trending page and return top 20 videos
    self.scrape_videos
  end

  def self.scrape_videos
    videos = []
    homepage = Nokogiri::HTML(open('https://www.vevo.com'))

    homepage.css("div.horiz-scroll-feed.feedV2-container.service-top-videos").each do |card|
      card.css("div.feed-item-info").each do |artist|
        video = self.new
        video.title = artist.css("a.feed-item-subtitle h3").text
        video.name = artist.css("a.feed-item-title").text
        video_url = artist.css("a.feed-item-subtitle").attr("href").value

        video.url = URI.join("https://www.vevo.com", video_url).to_s

        video_info = Nokogiri::HTML(open(video.url))
        video_info.css("div.video-details").each do |info|
          video.likes = info.css("span.likes")[0].text
          video.views = info.css("span.likes")[1].text
          video.director = info.css("div.more-details ul.credits li")[0].text
        end
        videos << video
      end
    end
    videos
  end

end
