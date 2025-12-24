# Versiyon Geçmişi

## v1.0.1 (24 Aralık 2024)

### Yeni Özellikler
- **Stimulus Controller Yönetimi:**
  - `rails-frontend add-stimulus CONTROLLER_ADI` komutu eklendi (kısa: `as`)
  - `rails-frontend delete-stimulus CONTROLLER_ADI` komutu eklendi (kısa: `ds`)
  - Stimulus controller silme öncesi view dosyalarında kullanım kontrolü
  - Kullanılan controller'lar için uyarı ve onay mekanizması

### Geliştirmeler
- Dokümantasyon güncellendi (README.md ve KULLANIM_KILAVUZU.md)
- Komut referansı tabloları güncellendi
- Stimulus controller örnekleri eklendi

---

## v1.0.0 (İlk Sürüm)

### Temel Özellikler
- **Proje Oluşturma:**
  - `rails-frontend new PROJE_ADI` komutu
  - `--clean` parametresi ile frontend odaklı proje oluşturma
  - Otomatik Tailwind CSS yapılandırması
  - Shared componentler (header, navbar, footer)

- **Sayfa Yönetimi:**
  - `rails-frontend add-page SAYFA_ADI` komutu
  - `rails-frontend delete-page SAYFA_ADI` komutu
  - Otomatik view, CSS ve Stimulus controller oluşturma
  - Otomatik route yapılandırması

- **Geliştirme Araçları:**
  - `rails-frontend run` komutu (server başlatma)
  - Türkçe karakter desteği (otomatik normalize)
  - Asset klasörleri (images, fonts)

- **Temizlik Özellikleri (`--clean`):**
  - Test dosyalarını atlama
  - Gereksiz Rails özelliklerini kaldırma (mailers, jobs, channels, models)
  - `.kamal` klasörünü temizleme

### Dokümantasyon
- Türkçe README.md
- Detaylı KULLANIM_KILAVUZU.md
- Otomatik kurulum scripti (install.sh)

### Teknik Detaylar
- Rails 7+ uyumluluğu
- Ruby 3.0+ desteği
- Tailwind CSS v4 entegrasyonu
- Stimulus framework desteği
