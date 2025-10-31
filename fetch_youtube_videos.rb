# Dosya Adı: fetch_youtube_videos.rb
require 'net/http'
require 'json'
require 'yaml'

API_KEY = ENV['YOUTUBE_API_KEY']
CHANNEL_ID = 'UC5glzJc5aNLMilAuoMn6aFQ'
PLAYLIST_ID = "UU#{CHANNEL_ID[2..-1]}"
REFERER = (ENV['YOUTUBE_REFERER'] || 'https://www.mehmetcemyucel.com/').strip

def ensure_api_key!(key)
  return unless key.nil? || key.strip.empty?

  warn 'HATA: YOUTUBE_API_KEY secretı veya ortam değişkeni tanımlı değil.'
  warn 'GitHub Actions > Settings > Secrets bölümünden API anahtarını ekleyin.'
  exit 1
end

def ensure_data_dir!
  Dir.mkdir('_data') unless Dir.exist?('_data')
end

# API çağrısının "part" kısmına 'contentDetails' ekledik, ancak 
# publishedAt verisi zaten 'snippet' içinde olduğu için sadece 'snippet' yeterli.
# Ancak bazen sadece playlistItems sadece snippet ile tam tarihi vermeyebilir. 
# Kontrol amaçlı publishedAt'ı çekiyoruz.

ensure_api_key!(API_KEY)

begin
  # API çağrısı, maxResults'u 100'e kadar çıkarabiliriz eğer çok video istiyorsak
  uri = URI("https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=#{PLAYLIST_ID}&maxResults=1000&key=#{API_KEY}") # Max sonuç sayısını artırdım
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(uri)
  request['Referer'] = REFERER unless REFERER.empty?

  response = http.request(request)

  unless response.is_a?(Net::HTTPSuccess)
    raise "YouTube API Hatası: HTTP #{response.code} #{response.message}"
  end

  data = JSON.parse(response.body)

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

  ensure_data_dir!
  File.write('_data/latest_videos.yml', videos.to_yaml)

  puts "YouTube'dan #{videos.count} video başarıyla çekildi ve _data/latest_videos.yml'ye yazıldı."

rescue => e
  warn "HATA: YouTube verisi çekilemedi. #{e.message}"
  ensure_data_dir!
  unless File.exist?('_data/latest_videos.yml')
    File.write('_data/latest_videos.yml', [].to_yaml)
  end
  exit 1
end
