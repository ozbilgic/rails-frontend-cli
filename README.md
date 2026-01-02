# Rails Frontend CLI

Rails Frontend CLI aracı frontend kodlama yapan programcıların işini oldukça kolaylaştıran, ruby yada rails bilinmesine gerek kalmadan rails ile frontend kodlamayı sevdiren bir araç.

## Dokümantasyon

Detaylı kullanım kılavuzu için [KULLANIM_KILAVUZU.md](KULLANIM_KILAVUZU.md) dosyasına bakın.

## Rails ile Frontend Kodlama Eğitimi

📚 [Eğitim materyali](https://gamma.app/docs/Rails-ile-Frontend-Kodlama-Egitimi-i6q19pjb2jpw9ny)

## Özellikler

✅ Rails 7+ ile uyumlu  
✅ Tailwind CSS otomatik yapılandırma  
✅ Stimulus controller desteği  
✅ Shared componentler (header, navbar, footer)  
✅ Layout ekleme desteği  
✅ Harici javascript kütüphanesi ekleme desteği  
✅ Otomatik route yapılandırması  
✅ CSS dosyaları otomatik import  
✅ Asset klasörleri (images, fonts)  
✅ Türkçe dokümantasyon  

## Hızlı Başlangıç

### Kurulum

**Tek Komutla Kurulum (Önerilen):**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ozbilgic/rails-frontend-cli/main/install.sh)
```

Kurulum tamamlandıktan sonra shell'i yeniden yükleyin:

```bash
source ~/.bashrc  # veya source ~/.zshrc
```

**Manuel Kurulum:**

Eğer curl kullanamıyorsanız:

```bash
# Repository'yi klonlayın
git clone https://github.com/ozbilgic/rails-frontend-cli.git ~/.rails-frontend-cli

# Kurulum scriptini çalıştırın
cd ~/.rails-frontend-cli
./install.sh
```

### Kaldırma

```bash
# Kurulumu kaldırın
rm -rf ~/.rails-frontend-cli

# Shell yapılandırmasından PATH'i kaldırın (~/.bashrc veya ~/.zshrc)
# "# Rails Frontend CLI" satırını ve altındaki export satırını silin
```

### Kurulumu Test Et

```bash
rails-frontend --version
# veya
rails-frontend version
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
rails-frontend remove-page iletisim

# Stimulus controller sil (kullanım kontrolü yapar)
rails-frontend remove-stimulus dropdown

# Layout ekle
rails-frontend add-layout iletisim

# Layout sil
rails-frontend remove-layout iletisim

# Harici javascript kütüphanesi ekle
rails-frontend add-pin alpinejs
rails-frontend add-pin sweetalert2

# Harici javascript kütüphanesi sil (kullanım kontrolü yapar)
rails-frontend remove-pin alpinejs
rails-frontend remove-pin sweetalert2
```

**`--clean` Parametresi:**
Frontend için gereksiz Rails özelliklerini kaldırır (test, mailers, jobs, channels, models, vb.). Frontend odaklı projeler için önerilir.

## Komutlar

| Komut | Kısa | Açıklama |
|-------|------|----------|
| `rails-frontend new PROJE [--clean]` | `n` | Yeni proje oluştur |
| `rails-frontend add-page SAYFA` | `ap` | Sayfa ekle |
| `rails-frontend remove-page SAYFA` | `rp` | Sayfa sil |
| `rails-frontend add-stimulus CONTROLLER` | `as` | Stimulus controller ekle |
| `rails-frontend remove-stimulus CONTROLLER` | `rs` | Stimulus controller sil |
| `rails-frontend add-layout LAYOUT` | `al` | Layout ekle |
| `rails-frontend remove-layout LAYOUT` | `rl` | Layout sil |
| `rails-frontend add-pin PAKET` | `pin` | Harici javascript kütüphanesi ekle |
| `rails-frontend remove-pin PAKET` | `unpin` | Harici javascript kütüphanesi sil |
| `rails-frontend update` | `u` | CLI'yi güncelle |
| `rails-frontend run` | `r` | Server başlat |
| `rails-frontend build` | `b` | Statik site oluştur |
| `rails-frontend version` | `-v` | Versiyon göster |
| `rails-frontend help` | `-h` | Yardım göster |

**Seçenekler:**
- `--clean`: Frontend için gereksiz dosyaları temizle (önerilen)

## Gereksinimler

- Ruby 3.0+
- Rails 7+

## Author

Levent Özbilgiç  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/leventozbilgic/)

## Lisans

GPLv3
