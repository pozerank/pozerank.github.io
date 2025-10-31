export YOUTUBE_API_KEY="[SİZİN_API_ANAHTARINIZI_BURAYA_YAPIŞTIRIN]"
ruby fetch_youtube_videos.rb
bundle exec jekyll serve

---

Spotify podcast verilerini yerelde çekmek için:
export SPOTIFY_CLIENT_ID="[SPOTIFY_CLIENT_ID]"
export SPOTIFY_CLIENT_SECRET="[SPOTIFY_CLIENT_SECRET]"
ruby fetch_spotify_podcasts.rb

---

Spotify embed kullanımı:
1. Yazının front matter alanına `spotify_episode_url: https://open.spotify.com/embed/episode/...` ekleyin.
2. İsteğe bağlı olarak `spotify_embed_height: 352` ile iframe yüksekliğini değiştirebilirsiniz.
