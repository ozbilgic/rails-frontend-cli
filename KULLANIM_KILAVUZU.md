# Rails Frontend CLI - Kullanım Kılavuzu

Frontend geliştiriciler için hazırlanmış, Rails projesi oluşturma ve yönetme aracı.

## 📦 Kurulum

### Adım 1: PATH'e Ekle

Aracı sistem genelinde kullanabilmek için PATH'inize ekleyin:

```bash
# ~/.bashrc veya ~/.zshrc dosyanıza ekleyin
export PATH="$PATH:/path_to/rails_frontend_cli"
```

Ardından terminal'i yeniden başlatın veya:

```bash
source ~/.bashrc  # veya source ~/.zshrc
```

### Adım 2: Kurulumu Test Et

```bash
rails-frontend --version
# veya
rails-f --version
```

## 🚀 Kullanım

### Yeni Proje Oluşturma

```bash
rails-frontend new PROJE_ADI
# veya kısa isim ile
rails-f new PROJE_ADI
```

**Örnek:**
```bash
rails-frontend new blog
cd blog
rails-frontend run
```

Tarayıcıda `http://localhost:3000` adresini açın.

### Yeni Sayfa Ekleme

Mevcut Rails projesinin içindeyken:

```bash
rails-frontend add-page SAYFA_ADI
# veya
rails-f ap SAYFA_ADI
```

**Örnekler:**
```bash
cd blog
rails-frontend add-page hakkimizda
rails-frontend add-page iletisim
rails-frontend add-page urunler
```

Her sayfa için otomatik olarak oluşturulur:
- Controller (`app/controllers/SAYFA_ADI_controller.rb`)
- View (`app/views/SAYFA_ADI/index.html.erb`)
- CSS dosyası (`app/assets/stylesheets/SAYFA_ADI.css`)
- Stimulus controller (`app/javascript/controllers/SAYFA_ADI_controller.js`)
- Route (`/SAYFA_ADI`)

### Sayfa Silme

```bash
rails-frontend delete-page SAYFA_ADI
# veya
rails-f dp SAYFA_ADI
```

**Örnek:**
```bash
rails-frontend delete-page iletisim
```

⚠️ **Not:** Home sayfası silinemez.

## 📁 Proje Yapısı

Yeni oluşturulan projeler şu yapıya sahiptir:

```
proje_adi/
├── app/
│   ├── controllers/
│   │   └── home_controller.rb
│   ├── views/
│   │   ├── home/
│   │   │   └── index.html.erb
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

## 🎨 Tailwind CSS Kullanımı

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

## ⚡ Stimulus Controller Kullanımı

Her sayfa için otomatik olarak bir Stimulus controller oluşturulur.

### Temel Kullanım

**HTML (View):**
```html
<div data-controller="hakkimizda">
  <button data-action="click->hakkimizda#greet">Tıkla</button>
  <p data-hakkimizda-target="output"></p>
</div>
```

**JavaScript (Controller):**
```javascript
// app/javascript/controllers/hakkimizda_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"]

  connect() {
    console.log("Hakkimizda controller bağlandı")
  }

  greet() {
    this.outputTarget.textContent = "Merhaba!"
  }
}
```

### Stimulus Özellikleri

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

## 🧩 Shared Componentler

Layout dosyası otomatik olarak shared componentleri içerir:

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

### Componentleri Özelleştirme

**Header:**
```erb
<!-- app/views/shared/_header.html.erb -->
<header class="bg-white shadow-sm">
  <nav class="container mx-auto px-4 py-4">
    <div class="flex items-center justify-between">
      <div class="text-2xl font-bold text-indigo-600">
        <%= link_to "Blog", root_path %>
      </div>
      <div class="hidden md:flex space-x-6">
        <%= link_to "Ana Sayfa", root_path, class: "text-gray-700 hover:text-indigo-600" %>
        <%= link_to "Hakkımızda", hakkimizda_path, class: "text-gray-700 hover:text-indigo-600" %>
        <%= link_to "İletişim", iletisim_path, class: "text-gray-700 hover:text-indigo-600" %>
      </div>
    </div>
  </nav>
</header>
```

## 🛣️ Routes

Routes otomatik olarak yapılandırılır:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root "home#index"
  get '/hakkimizda', to: 'hakkimizda#index'
  get '/iletisim', to: 'iletisim#index'
end
```

### Named Routes Kullanımı

```erb
<%= link_to "Ana Sayfa", root_path %>
<%= link_to "Hakkımızda", hakkimizda_path %>
<%= link_to "İletişim", iletisim_path %>
```

## 📝 Komut Referansı

| Komut | Kısa İsim | Açıklama |
|-------|-----------|----------|
| `rails-frontend new PROJE` | `rails-f n PROJE` | Yeni proje oluştur |
| `rails-frontend add-page SAYFA` | `rails-f ap SAYFA` | Sayfa ekle |
| `rails-frontend delete-page SAYFA` | `rails-f dp SAYFA` | Sayfa sil |
| `rails-frontend version` | `rails-f -v` | Versiyon göster |
| `rails-frontend help` | `rails-f -h` | Yardım göster |

## 🔧 Sık Karşılaşılan Sorunlar

### 1. Komut bulunamadı hatası

**Sorun:** `rails-frontend: command not found`

**Çözüm:**
```bash
# PATH'e eklendiğinden emin olun
echo $PATH | grep rails_frontend_cli

# Yoksa ~/.bashrc veya ~/.zshrc'ye ekleyin
export PATH="$PATH:/home/levent/rails_frontend_cli"
source ~/.bashrc
```

### 2. Tailwind CSS çalışmıyor

**Sorun:** Tailwind sınıfları uygulanmıyor

**Çözüm:**
```bash
# Tailwind'i yeniden derleyin
bin/rails tailwindcss:build

# Geliştirme modunda otomatik derleme için
bin/rails tailwindcss:watch
```

### 3. Stimulus controller çalışmıyor

**Sorun:** Console'da "Controller not found" hatası

**Çözüm:**
```bash
# JavaScript'leri yeniden derleyin
bin/rails assets:precompile

# Geliştirme modunda server'ı yeniden başlatın
bin/rails server
```

### 4. Türkçe karakter sorunları

**Sorun:** Sayfa adlarında Türkçe karakter kullanıldığında hata

**Çözüm:** Araç otomatik olarak Türkçe karakterleri dönüştürür:
- `hakkımızda` → `hakkimizda`
- `ürünler` → `urunler`
- `iletişim` → `iletisim`

## 💡 İpuçları

### 1. Hızlı Geliştirme

```bash
# Terminal 1: Rails server
bin/rails server

# Terminal 2: Tailwind watch (otomatik derleme)
bin/rails tailwindcss:watch
```

### 2. Sayfa Şablonu Oluşturma

Sık kullanılan sayfa yapıları için kendi şablonlarınızı oluşturun:

```erb
<!-- app/views/shared/_page_template.html.erb -->
<div class="container mx-auto px-4 py-16">
  <h1 class="text-4xl font-bold mb-8"><%= title %></h1>
  <%= yield %>
</div>
```

### 3. Component Kütüphanesi

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

## 🎯 Örnek Proje Akışı

```bash
# 1. Yeni proje oluştur
rails-frontend new blog
cd blog

# 2. Server'ı başlat
bin/rails server

# 3. Yeni terminal açıp sayfalar ekle
rails-frontend add-page hakkimizda
rails-frontend add-page yazilar
rails-frontend add-page iletisim

# 4. Shared componentleri özelleştir
# app/views/shared/_header.html.erb dosyasını düzenle

# 5. Tailwind watch başlat (opsiyonel)
bin/rails tailwindcss:watch

# 6. Geliştirmeye başla!
```

## 📚 Ek Kaynaklar

- **Rails Guides:** https://guides.rubyonrails.org/
- **Tailwind CSS:** https://tailwindcss.com/docs
- **Stimulus:** https://stimulus.hotwired.dev/
- **Hotwire:** https://hotwired.dev/

## 🆘 Destek

Sorun yaşarsanız:

1. `rails-frontend help` komutunu çalıştırın
2. Rails log dosyalarını kontrol edin: `log/development.log`
3. Browser console'u kontrol edin (F12)

## 📄 Lisans

Bu araç MIT lisansı altında sunulmaktadır.

---

**İyi kodlamalar! 🚀**
