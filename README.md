# Rails Frontend CLI

Frontend geliştiriciler için hazırlanmış Rails projesi oluşturma ve yönetme aracı.

## Özellikler

✅ Rails 7+ ile uyumlu  
✅ Tailwind CSS otomatik yapılandırma  
✅ Stimulus controller desteği  
✅ Shared componentler (header, navbar, footer)  
✅ Otomatik route yapılandırması  
✅ CSS dosyaları otomatik import  
✅ Asset klasörleri (images, fonts)  
✅ Türkçe çıktılar ve dokümantasyon  

## Hızlı Başlangıç

### Kurulum

**Otomatik Kurulum (Önerilen):**

```bash
git clone https://github.com/KULLANICI_ADI/rails_frontend_cli.git
cd rails_frontend_cli
./install.sh
source ~/.bashrc  # veya source ~/.zshrc
```

**Manuel Kurulum:**

```bash
git clone https://github.com/KULLANICI_ADI/rails_frontend_cli.git
cd rails_frontend_cli
chmod +x rails-frontend rails-f rails_frontend_setup.rb

# PATH'e ekleyin (~/.bashrc veya ~/.zshrc)
export PATH="$PATH:$(pwd)"
source ~/.bashrc
```

### Kullanım

```bash
# Yeni proje oluştur (standart)
rails-frontend new blog
cd blog
bin/rails server

# Yeni proje oluştur (temiz frontend - önerilen)
rails-frontend new blog --clean
cd blog
rails-frontend run

# Sayfa ekle
rails-frontend add-page hakkimizda
rails-frontend add-page iletisim

# Sayfa sil
rails-frontend delete-page iletisim
```

**`--clean` Parametresi:**
Frontend için gereksiz Rails özelliklerini kaldırır (test, mailers, jobs, channels, vb.). Frontend odaklı projeler için önerilir.

## Komutlar

| Komut | Kısa İsim | Açıklama |
|-------|-----------|----------|
| `rails-frontend new PROJE [--clean]` | `rails-f n PROJE [--clean]` | Yeni proje oluştur |
| `rails-frontend add-page SAYFA` | `rails-f ap SAYFA` | Sayfa ekle |
| `rails-frontend delete-page SAYFA` | `rails-f dp SAYFA` | Sayfa sil |
| `rails-frontend run` | `rails-f r` | Server başlat (bin/dev) |
| `rails-frontend version` | `rails-f -v` | Versiyon göster |
| `rails-frontend help` | `rails-f -h` | Yardım göster |

**Seçenekler:**
- `--clean`: Frontend için gereksiz dosyaları temizle (önerilen)

## Dokümantasyon

Detaylı kullanım kılavuzu için [KULLANIM_KILAVUZU.md](KULLANIM_KILAVUZU.md) dosyasına bakın.

## Gereksinimler

- Ruby 3.0+
- Rails 8.0+
- Node.js (Tailwind CSS için)

## Lisans

MIT
