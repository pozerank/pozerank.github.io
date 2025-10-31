# Gerekli kütüphaneleri dahil et
require 'httparty'
require 'json'
require 'base64'
require 'yaml'
require 'fileutils' # Yeni: Dizin oluşturmak için FileUtils kütüphanesini dahil et

# Podcast listesi (Çekmek istediğiniz Spotify Podcast ID'lerini buraya ekleyin)
# ID'yi Spotify URL'sinden alabilirsiniz: https://open.spotify.com/show/[ID]
PODCAST_IDS = [
  '5YNVcnnKsZnENphY0IuXoD' # Eklenen podcast ID'si
].freeze

# Spotify API uç noktaları
TOKEN_URL = 'https://accounts.spotify.com/api/token'.freeze
API_URL = 'https://api.spotify.com/v1/shows/'.freeze
OUTPUT_DIR = '_data' # Yeni: Çıktı dizinini tanımla
OUTPUT_FILE = "#{OUTPUT_DIR}/latest_podcasts.yml".freeze # Dosya yolunu oluştur

# GitHub Actions Secrets'tan kimlik bilgilerini al
CLIENT_ID = ENV['SPOTIFY_CLIENT_ID']
CLIENT_SECRET = ENV['SPOTIFY_CLIENT_SECRET']

# Access Token almak için fonksiyon
def get_access_token
  # Client ID ve Secret Base64 ile encode edilir
  auth_header = Base64.strict_encode64("#{CLIENT_ID}:#{CLIENT_SECRET}")

  response = HTTParty.post(
    TOKEN_URL,
    headers: {
      'Authorization' => "Basic #{auth_header}",
      'Content-Type' => 'application/x-www-form-urlencoded'
    },
    body: {
      'grant_type' => 'client_credentials'
    }
  )

  unless response.success?
    puts "HATA: Spotify Access Token alınamadı. Yanıt: #{response.code} - #{response.body}"
    exit 1
  end

  JSON.parse(response.body)['access_token']
rescue StandardError => e
  puts "HATA: Access Token alımı sırasında bir hata oluştu: #{e.message}"
  exit 1
end

# Tek bir podcast'in son bölümlerini çeken ana fonksiyon
def fetch_podcast_episodes(token)
  all_episodes = []

  PODCAST_IDS.each do |podcast_id|
    puts "-> Podcast ID: #{podcast_id} için bölümler çekiliyor..."
    
    begin
      # Podcast bölümlerinin uç noktası (limit 5: en son 5 bölümü alır)
      episodes_url = "#{API_URL}#{podcast_id}/episodes"

      response = HTTParty.get(
        episodes_url,
        headers: {
          'Authorization' => "Bearer #{token}",
          'Content-Type' => 'application/json'
        }
      )

      unless response.success?
        puts "UYARI: Podcast bölümleri çekilemedi. ID: #{podcast_id}. Yanıt: #{response.code} - #{response.body}"
        next
      end

      data = JSON.parse(response.body)
      
      # Eğer items dizisi boşsa veya nil ise atla
      next if data['items'].nil? || data['items'].empty?

      # GÜNCELLENMİŞ VE GÜVENLİ ÇEKİM: &. operatörünü kullanıyoruz
      # show_name, ilk bölümün içindeki 'show' nesnesinden alınır.
      show_name = data['items'].first&.dig('show', 'name') || 'Bilinmeyen Podcast'

      data['items'].each do |episode|
        # Bölüm nesnesinin geçerli olduğundan emin olun
        next if episode.nil?
        
        # Bölümün çalınabilir embed URL'si
        embed_url = "https://open.spotify.com/embed/episode/#{episode['id']}"

        all_episodes << {
          'show_name' => show_name,
          'episode_name' => episode['name'],
          'description' => episode['description'],
          'release_date' => episode['release_date'],
          'date' => episode['release_date'],
          'duration_ms' => episode['duration_ms'],
          'embed_url' => embed_url,
          'url' => episode.dig('external_urls', 'spotify')
        }
      end

    rescue StandardError => e
      puts "UYARI: ID #{podcast_id} için veri işlenirken hata oluştu: #{e.message}"
      # Hata olsa bile döngüye devam et
      next
    end
  end
  all_episodes
end

# YAML dosyasını oluşturan fonksiyon
def save_data_to_yaml(data)
  # YENİ EKLENTİ: _data dizinini kontrol et ve yoksa oluştur
  FileUtils.mkdir_p(OUTPUT_DIR) unless File.directory?(OUTPUT_DIR)
  
  File.open(OUTPUT_FILE, 'w') do |file|
    file.write(data.to_yaml)
  end
  puts "Başarılı: #{data.count} bölüm, #{OUTPUT_FILE} dosyasına kaydedildi."
end

# Ana çalıştırma bloğu
begin
  puts 'Spotify Access Token alınıyor...'
  access_token = get_access_token

  puts 'Access Token başarıyla alındı. Bölümler çekiliyor...'
  podcast_data = fetch_podcast_episodes(access_token)

  # Tüm bölümleri tarihe göre sırala (en yenisi başta)
  podcast_data.sort_by! { |episode| episode['release_date'] || '0000-01-01' }.reverse!

  save_data_to_yaml(podcast_data)
rescue StandardError => e
  # Bu kritik hata, token alma hatası veya dosya yazma hatası gibi sorunları yakalar.
  puts "Kritik HATA: Betik çalışmayı durdurdu. #{e.message}"
  exit 1
end
