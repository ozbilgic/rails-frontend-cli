# Versiyon Geçmişi

## v1.0.2

### Yeni Özellikler
- **Layout Yönetimi:**
  - `rails-frontend add-layout LAYOUT_ADI` komutu eklendi (kısa: `al`)
  - `rails-frontend remove-layout LAYOUT_ADI` komutu eklendi (kısa: `rl`)
  - Otomatik view eşleştirme (layout adı ile view adı eşleşiyorsa)
  - Kullanıcıya view seçimi sorma (eşleşme yoksa)
  - Aynı view için çift layout kontrolü
  - Controller'a otomatik layout direktifi ekleme/kaldırma

### Geliştirmeler
- Layout dosyası oluşturma (`app/views/layouts/`)
- `home_controller.rb`'ye `layout "layout_adi", only: :view_adi` direktifi ekleme
- Layout silme öncesi onay mekanizması
- Mevcut layout kontrolü ile çakışma önleme

### Dokümantasyon
- README.md güncellendi
- KULLANIM_KILAVUZU.md'ye layout yönetimi bölümü eklendi
- Komut referansı tabloları güncellendi

---

## v1.0.1

### Yeni Özellikler
- **Stimulus Controller Yönetimi:**
  - `rails-frontend add-stimulus CONTROLLER_ADI` komutu eklendi (kısa: `as`)
  - `rails-frontend remove-stimulus CONTROLLER_ADI` komutu eklendi (kısa: `ds`)
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
  - `rails-frontend remove-page SAYFA_ADI` komutu
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
