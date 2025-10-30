# Dosya Adı: fetch_youtube_videos.rb
require 'net/http'
require 'json'
require 'yaml'

API_KEY = ENV['YOUTUBE_API_KEY']
CHANNEL_ID = 'UC5glzJc5aNLMilAuoMn6aFQ'
PLAYLIST_ID = "UU#{CHANNEL_ID[2..-1]}"

# API çağrısının "part" kısmına 'contentDetails' ekledik, ancak 
# publishedAt verisi zaten 'snippet' içinde olduğu için sadece 'snippet' yeterli.
# Ancak bazen sadece playlistItems sadece snippet ile tam tarihi vermeyebilir. 
# Kontrol amaçlı publishedAt'ı çekiyoruz.

begin
  # API çağrısı, maxResults'u 100'e kadar çıkarabiliriz eğer çok video istiyorsak
  uri = URI("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=#{PLAYLIST_ID}&maxResults=1000&key=#{API_KEY}") # Max sonuç sayısını artırdım
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)

  if data.key?('error')
    raise "YouTube API Hatası: #{data['error']['message']}"
  end
  
  videos = data['items'].map do |item|
      {
          'title' => item['snippet']['title'],
          'description' => item['snippet']['description'],
          'date' => item['snippet']['publishedAt'],
          'video_id' => item['snippet']['resourceId']['videoId']
      }
  end

  Dir.mkdir('_data') unless File.exist?('_data')
  File.open('_data/latest_videos.yml', 'w') { |file| file.write(videos.to_yaml) }

  puts "YouTube'dan #{videos.count} video başarıyla çekildi ve _data/latest_videos.yml'ye yazıldı."

rescue => e
  puts "HATA: YouTube verisi çekilemedi. #{e.message}"
  Dir.mkdir('_data') unless File.exist?('_data')
  File.open('_data/latest_videos.yml', 'w') { |file| file.write("[]") }
end
