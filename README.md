# Rails Frontend CLI

Frontend geliştiriciler için hazırlanmış Rails projesi oluşturma ve yönetme aracı.

## Özellikler

✅ Rails 8+ ile uyumlu  
✅ Tailwind CSS otomatik yapılandırma  
✅ Stimulus controller desteği  
✅ Shared componentler (header, navbar, footer)  
✅ Otomatik route yapılandırması  
✅ CSS dosyaları otomatik import  
✅ Asset klasörleri (images, fonts)  
✅ Türkçe çıktılar ve dokümantasyon  

## Hızlı Başlangıç

### Kurulum

```bash
# PATH'e ekleyin (~/.bashrc veya ~/.zshrc)
export PATH="$PATH:/path_to/rails_frontend_cli"
source ~/.bashrc
```

### Kullanım

```bash
# Yeni proje oluştur
rails-frontend new blog
cd blog
bin/rails server

# Sayfa ekle
rails-frontend add-page hakkimizda
rails-frontend add-page iletisim

# Sayfa sil
rails-frontend delete-page iletisim
```

## Komutlar

| Komut | Kısa İsim | Açıklama |
|-------|-----------|----------|
| `rails-frontend new PROJE` | `rails-f n PROJE` | Yeni proje oluştur |
| `rails-frontend add-page SAYFA` | `rails-f ap SAYFA` | Sayfa ekle |
| `rails-frontend delete-page SAYFA` | `rails-f dp SAYFA` | Sayfa sil |
| `rails-frontend run` | `rails-f r` | Server başlat (bin/dev) |
| `rails-frontend version` | `rails-f -v` | Versiyon göster |
| `rails-frontend help` | `rails-f -h` | Yardım göster |

## Dokümantasyon

Detaylı kullanım kılavuzu için [KULLANIM_KILAVUZU.md](KULLANIM_KILAVUZU.md) dosyasına bakın.

## Gereksinimler

- Ruby 3.0+
- Rails 8.0+
- Node.js (Tailwind CSS için)

## Lisans

MIT
