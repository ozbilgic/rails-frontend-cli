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
✅ Türkçe dokümantasyon  

## Hızlı Başlangıç

### Kurulum

**Otomatik Kurulum (Önerilen):**

```bash
git clone https://github.com/ozbilgic/rails-frontend-cli.git
cd rails-frontend-cli
./install.sh
source ~/.bashrc  # veya source ~/.zshrc
```

**Manuel Kurulum:**

```bash
git clone https://github.com/ozbilgic/rails-frontend-cli.git
cd rails-frontend-cli
chmod +x rails-frontend rails_frontend_setup.rb

# PATH'e ekleyin (~/.bashrc veya ~/.zshrc)
export PATH="$PATH:$(pwd)"
source ~/.bashrc
```

### Kullanım

```bash
# Yeni proje oluştur (temiz frontend - önerilen)
# Frontend için gerekli olmayan dosyalar oluşturulmaz
rails-frontend new blog --clean
cd blog
rails-frontend run

# Sayfa ekle
rails-frontend add-page hakkimizda
rails-frontend add-page iletisim

# Stimulus controller ekle
rails-frontend add-stimulus dropdown
rails-frontend add-stimulus modal

# Sayfa sil
rails-frontend delete-page iletisim

# Stimulus controller sil (kullanım kontrolü yapar)
rails-frontend delete-stimulus dropdown
```

**`--clean` Parametresi:**
Frontend için gereksiz Rails özelliklerini kaldırır (test, mailers, jobs, channels, models, vb.). Frontend odaklı projeler için önerilir.

## Komutlar

| Komut | Kısa | Açıklama |
|-------|------|----------|
| `rails-frontend new PROJE [--clean]` | `n` | Yeni proje oluştur |
| `rails-frontend add-page SAYFA` | `ap` | Sayfa ekle |
| `rails-frontend delete-page SAYFA` | `dp` | Sayfa sil |
| `rails-frontend add-stimulus CONTROLLER` | `as` | Stimulus controller ekle |
| `rails-frontend delete-stimulus CONTROLLER` | `ds` | Stimulus controller sil |
| `rails-frontend run` | `r` | Server başlat (bin/dev) |
| `rails-frontend version` | `-v` | Versiyon göster |
| `rails-frontend help` | `-h` | Yardım göster |

**Seçenekler:**
- `--clean`: Frontend için gereksiz dosyaları temizle (önerilen)

## Dokümantasyon

Detaylı kullanım kılavuzu için [KULLANIM_KILAVUZU.md](KULLANIM_KILAVUZU.md) dosyasına bakın.

## Gereksinimler

- Ruby 3.0+
- Rails 7+
- Node.js (Tailwind CSS için)

## Lisans

MIT
