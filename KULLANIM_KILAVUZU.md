# Rails Frontend CLI - Kullanım Kılavuzu

Rails Frontend CLI aracı frontend kodlama yapan programcıların işini oldukça kolaylaştıran, ruby yada rails bilinmesine gerek kalmadan rails ile frontend kodlamayı sevdiren bir araç.

## Rails ile Frontend Kodlama Eğitimi

📚 [Eğitim materyali](https://gamma.app/docs/Rails-ile-Frontend-Kodlama-Egitimi-i6q19pjb2jpw9ny)

## Kurulum

### Otomatik Kurulum (Önerilen)

```bash
git clone https://github.com/ozbilgic/rails-frontend-cli.git
cd rails-frontend-cli
./install.sh
source ~/.bashrc  # veya source ~/.zshrc
```

### Manuel Kurulum

```bash
git clone https://github.com/ozbilgic/rails-frontend-cli.git
cd rails-frontend-cli
chmod +x rails-frontend rails-frontend rails_frontend_setup.rb

# PATH'e ekleyin (~/.bashrc veya ~/.zshrc)
export PATH="$PATH:$(pwd)"
source ~/.bashrc
```

### Kurulumu Test Et

```bash
# Yeni versiyon bilgisi için:
rails-frontend --version
# veya
rails-frontend version
```

## Kullanım

### Yeni Proje Oluşturma

```bash
# Temiz frontend projesi (önerilen)
# Frontend için gerekli olmayan dosyalar oluşturulmaz
rails-frontend new blog --clean
cd blog
rails-frontend run

# Standart proje
rails-frontend new blog
cd blog
rails-frontend run
```

Tarayıcıda `http://localhost:3000` adresini açın.

### `--clean` Parametresi

`--clean` parametresi ile proje oluşturulduğunda, frontend geliştirme için gereksiz Rails özellikleri kaldırılır:

**Atlanılan Özellikler:**
- Test dosyaları (`--skip-test`, `--skip-system-test`)
- Action Mailer (`--skip-action-mailer`)
- Action Mailbox (`--skip-action-mailbox`)
- Action Text (`--skip-action-text`)
- Active Job (`--skip-active-job`)
- Action Cable (`--skip-action-cable`)

**Silinen Dosya ve Klasörler:**
- `app/mailers/`
- `app/jobs/`
- `app/models`
- `test/`
- `app/channels/`
- `config/cable.yml`, `config/queue.yml`, `config/recurring.yml`
- `db/queue_schema.rb`, `db/cable_schema.rb`
- `bin/jobs`
- `.kamal`

### Yeni Sayfa Ekleme

Mevcut Rails projesinin içindeyken:

```bash
rails-frontend add-page SAYFA_ADI
```

**Örnekler:**
```bash
cd blog
rails-frontend add-page hakkımızda
rails-frontend add-page iletişim
rails-frontend add-page ürünler
```

Her sayfa için otomatik olarak oluşturulur:
- View (`app/views/home/SAYFA_ADI.html.erb`) - home klasöründe
- CSS dosyası (`app/assets/stylesheets/SAYFA_ADI.css`)
- Home controller'a action eklenir
- Route (`/SAYFA_ADI` -> `home#SAYFA_ADI`)

### Server Başlatma

```bash
rails-frontend run
```

Bu komut `bin/dev` dosyasını çalıştırarak Rails server'ı başlatır.

### Statik Site Oluşturma

```bash
rails-frontend build
# veya kısa isim
rails-frontend b
```

**Nasıl Çalışır:**
1. Rails server'ın çalıştığını kontrol eder
2. `build/` klasörü varsa temizler ve yeniden hazırlar
3. `build/assets/{img,js,css,fonts}` klasörlerini oluşturur
4. Tüm dosyaları organize eder (image, js, css, font)
5. HTML ve CSS dosyalarında path'leri düzeltir
6. HTML dosyalarını temizler (csrf, index.html linkleri)

**Önemli:** Bu komut çalıştırılmadan önce Rails server başlatılmış olmalıdır!

**Örnek Kullanım:**
```bash
# Terminal 1 - Server başlat
rails-frontend run

# Terminal 2 - Build oluştur
rails-frontend build

# Build klasörünü test et
cd build && npx http-server -p 8000
```

**Oluşturulan Klasör Yapısı:**
```
build/
├── assets/
│   ├── img/          # Tüm image dosyaları
│   ├── js/           # Tüm JavaScript dosyaları
│   ├── css/          # Tüm CSS dosyaları
│   └── fonts/        # Tüm font dosyaları
└── *.html            # HTML sayfaları
```

### Sayfa Silme

```bash
rails-frontend remove-page SAYFA_ADI
```

**Örnek:**
```bash
rails-frontend remove-page iletişim
```

**Not:** Ana sayfa (home/index) silinemez.

### Stimulus Controller Ekleme

```bash
rails-frontend add-stimulus CONTROLLER_ADI
```

**Örnekler:**
```bash
cd blog
rails-frontend add-stimulus dropdown
rails-frontend add-stimulus modal
rails-frontend add-stimulus tabs
```

Bu komut otomatik olarak oluşturur:
- Stimulus controller (`app/javascript/controllers/CONTROLLER_ADI_controller.js`)
- Türkçe karakterler normalize edilir

### Stimulus Controller Silme

```bash
rails-frontend remove-stimulus CONTROLLER_ADI
```

**Örnekler:**
```bash
rails-frontend remove-stimulus dropdown
rails-frontend remove-stimulus modal
```

**Önemli:** Bu komut silmeden önce:
1. Controller dosyasının varlığını kontrol eder
2. `app/views` altındaki tüm HTML dosyalarında kullanım kontrolü yapar
3. Eğer controller kullanılıyorsa, kullanılan dosyaları listeler
4. Kullanıcıdan onay ister

**Örnek Çıktı:**
```
UYARI: Bu controller aşağıdaki dosyalarda kullanılıyor:
  - app/views/home/index.html.erb
  - app/views/home/products.html.erb

Yine de silmek istiyor musunuz? (y/n):
```

### Layout Ekleme

```bash
rails-frontend add-layout LAYOUT_ADI
```

**Örnekler:**
```bash
cd blog
rails-frontend add-layout iletisim
```

**Nasıl Çalışır:**
1. Layout adı ile eşleşen view dosyası aranır
2. Eşleşen view varsa otomatik olarak layout dosyası oluşturulur
3. Eşleşen view yoksa kullanıcıya hangi view ile kullanılacağı sorulur
4. Aynı view için mevcut layout kontrolü yapılır
5. Layout dosyası oluşturulur (`app/views/layouts/`)
6. `home_controller.rb`'ye layout ataması eklenir

### Layout Silme

```bash
rails-frontend remove-layout LAYOUT_ADI
```

**Örnekler:**
```bash
rails-frontend remove-layout iletisim
```

**Önemli:** Bu komut silmeden önce:
1. Layout dosyasının varlığını kontrol eder
2. Kullanıcıdan onay ister
3. Controller'dan layout atamasını kaldırır
4. Layout dosyasını siler

### Javascript Kütüphanesi Ekleme

```bash
rails-frontend add-pin PAKET_ADI
```

**Örnekler:**
```bash
cd blog
rails-frontend add-pin alpinejs
rails-frontend add-pin sweetalert2
rails-frontend add-pin chart.js
```

**Nasıl Çalışır:**
1. Paket jspm'den bulunup `config/importmap.rb`'ye eklenir
2. Başarılı olursa kullanıcıya import hatırlatması yapılır

**Önemli:** Pin ekledikten sonra JavaScript dosyanıza import etmeyi unutmayın:
```javascript
// app/javascript/application.js
import Swal from "sweetalert2"
```

### Javascript Kütüphanesi Silme

```bash
rails-frontend remove-pin PAKET_ADI
```

**Örnekler:**
```bash
rails-frontend remove-pin alpinejs
rails-frontend remove-pin sweetalert2
```

**Önemli:** Bu komut silmeden önce:
1. JavaScript dosyalarında kullanım kontrolü yapar (`app/javascript/**/*.js`)
2. HTML dosyalarında kullanım kontrolü yapar (`app/views/**/*.html.erb`)
3. Pin'in `config/importmap.rb`'de olup olmadığını kontrol eder
4. Kullanılıyorsa kullanıcıya uyarı gösterir ve onay ister

### CLI Güncelleme

```bash
rails-frontend update
```

## Proje Yapısı

Yeni oluşturulan projeler şu yapıya sahiptir:

```
proje_adi/
├── app/
│   ├── controllers/
│   │   └── home_controller.rb  (tüm action'lar burada)
│   ├── views/
│   │   ├── home/
│   │   │   ├── index.html.erb
│   │   │   ├── hakkimizda.html.erb
│   │   │   └── iletisim.html.erb
│   │   ├── shared/
│   │   │   ├── _header.html.erb
│   │   │   ├── _navbar.html.erb
│   │   │   └── _footer.html.erb
│   │   └── layouts/
│   │       └── application.html.erb (güncellenmiş)
│   ├── assets/
│   │   ├── stylesheets/
│   │   │   ├── application.tailwind.css
│   │   │   ├── home.css
│   │   │   ├── header.css
│   │   │   ├── navbar.css
│   │   │   └── footer.css
│   │   ├── images/
│   │   └── fonts/
│   └── javascript/
│       └── controllers/
│           └── home_controller.js
└── config/
    └── routes.rb (root ayarlanmış)
```

## Tailwind CSS Kullanımı

Projeler Tailwind CSS ile gelir. Doğrudan Tailwind sınıflarını kullanabilirsiniz:

```html
<div class="container mx-auto px-4 py-8">
  <h1 class="text-4xl font-bold text-blue-600">Başlık</h1>
  <p class="text-gray-700 mt-4">İçerik...</p>
</div>
```

### Özel CSS Ekleme

Her sayfa için otomatik oluşturulan CSS dosyasını kullanabilirsiniz:

```css
/* app/assets/stylesheets/hakkimizda.css */
.hakkimizda-container {
  background: linear-gradient(to right, #667eea, #764ba2);
}
```

CSS dosyaları otomatik olarak `application.tailwind.css` dosyasına import edilir.

### Stimulus Özellikleri ve Kullanım Örneği

- **Targets:** DOM elementlerine kolay erişim
- **Actions:** Event handling
- **Values:** Data attributes ile veri paylaşımı

**Örnek:**
```html
<div data-controller="urunler" 
     data-urunler-count-value="0">
  <button data-action="urunler#increment">+</button>
  <span data-urunler-target="counter">0</span>
</div>
```

```javascript
export default class extends Controller {
  static targets = ["counter"]
  static values = { count: Number }

  increment() {
    this.countValue++
    this.counterTarget.textContent = this.countValue
  }
}
```

## Shared Componentler

Ana layout dosyası otomatik olarak shared componentleri içerir:
Dilediğiniz gibi düzenleyebilirsiniz.

```erb
<!-- app/views/layouts/application.html.erb -->
<body class="flex flex-col min-h-screen">
  <%= render 'shared/header' %>
  
  <main class="flex-grow">
    <%= yield %>
  </main>
  
  <%= render 'shared/footer' %>
</body>
```

### Link Kullanımı

```erb
<%= link_to "Ana Sayfa", root_path %>
<%= link_to "Hakkımızda", hakkimizda_path %>
<%= link_to "İletişim", iletisim_path %>
```

## Komut Referansı

| Komut | Kısa İsim | Açıklama |
|-------|-----------|----------|
| `rails-frontend new PROJE [--clean]` | `n` | Yeni proje oluştur |
| `rails-frontend build` | `b` | Statik site oluştur |
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
| `rails-frontend version` | `-v` | Versiyon göster |
| `rails-frontend help` | `-h` | Yardım göster |

## Sık Karşılaşılan Sorunlar

### 1. Komut bulunamadı hatası

**Sorun:** `rails-frontend: command not found`

**Çözüm:**
```bash
# PATH'e eklendiğinden emin olun
echo $PATH | grep rails-frontend-cli

# Yoksa ~/.bashrc veya ~/.zshrc'ye ekleyin
export PATH="$PATH:$(pwd)"
source ~/.bashrc
```

### 2. Tailwind CSS çalışmıyor

**Sorun:** Tailwind sınıfları uygulanmıyor

**Çözüm:**
```bash
# Tailwind'i yeniden derleyin (Proje klasöründeyken)
bin/rails tailwindcss:build
```

### 3. Stimulus controller çalışmıyor

**Sorun:** Console'da "Controller not found" hatası

**Çözüm:**
```bash
# JavaScript'leri yeniden derleyin (Proje klasöründeyken)
bin/rails assets:precompile
```

### 4. Türkçe karakter sorunları

**Sorun:** Sayfa adlarında Türkçe karakter kullanıldığında hata

**Çözüm:** Türkçe karakterler artık otomatik olarak dönüştürülüyor:
- `hakkımızda` → `hakkimizda`
- `ürünler` → `urunler`
- `iletişim` → `iletisim`

## İpuçları

### 2. Component Kütüphanesi

Tekrar kullanılabilir componentler oluşturun:

```erb
<!-- app/views/shared/_card.html.erb -->
<div class="bg-white rounded-lg shadow-lg p-6">
  <h3 class="text-xl font-bold mb-2"><%= title %></h3>
  <p class="text-gray-600"><%= content %></p>
</div>
```

Kullanımı:
```erb
<%= render 'shared/card', title: 'Başlık', content: 'İçerik' %>
```

## Ek Kaynaklar

- **Tailwind CSS:** https://tailwindcss.com/docs
- **Stimulus:** https://stimulus.hotwired.dev/
- **SCSS:** https://sass-lang.com/documentation/syntax/

## Destek

Sorun yaşarsanız:

1. `rails-frontend help` komutunu çalıştırın
2. Rails log dosyalarını kontrol edin: `log/development.log`
3. Browser console'u kontrol edin (F12)

## Author

Levent Özbilgiç  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/leventozbilgic/)

## Lisans

GPLv3

---

**İyi kodlamalar! 🚀**
