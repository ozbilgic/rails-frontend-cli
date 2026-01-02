#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'optparse'

class RailsFrontendCLI
  VERSION  = "1.0.4"
  AUTHOR   = "Levent Özbilgiç"
  LINKEDIN = "https://www.linkedin.com/in/leventozbilgic/"
  GITHUB   = "https://github.com/ozbilgic"

  def initialize
    @proje_adi = nil
    @sayfa_adi = nil
    @komut = nil
    @clean_mode = false
  end

  def calistir(args)
    if args.empty?
      yardim_goster
      exit 0
    end

    @komut = args[0]

    case @komut
    when 'new', 'n'
      @proje_adi = args[1]
      if @proje_adi.nil? || @proje_adi.empty?
        hata_mesaji("Proje adı belirtilmedi. Kullanım: rails-frontend new PROJE_ADI [--clean]")
      end
      # --clean parametresini kontrol et
      @clean_mode = args.include?('--clean')
      yeni_proje_olustur
    when 'add-page', 'ap'
      @sayfa_adi = args[1]
      if @sayfa_adi.nil? || @sayfa_adi.empty?
        hata_mesaji("Sayfa adı belirtilmedi. Kullanım: rails-frontend add-page SAYFA_ADI")
      end
      sayfa_ekle
    when 'remove-page', 'rp'
      @sayfa_adi = args[1]
      if @sayfa_adi.nil? || @sayfa_adi.empty?
        hata_mesaji("Sayfa adı belirtilmedi. Kullanım: rails-frontend remove-page SAYFA_ADI")
      end
      sayfa_sil
    when 'add-stimulus', 'as'
      @controller_adi = args[1]
      if @controller_adi.nil? || @controller_adi.empty?
        hata_mesaji("Controller adı belirtilmedi. Kullanım: rails-frontend add-stimulus CONTROLLER_ADI")
      end
      stimulus_ekle
    when 'remove-stimulus', 'rs'
      @controller_adi = args[1]
      if @controller_adi.nil? || @controller_adi.empty?
        hata_mesaji("Controller adı belirtilmedi. Kullanım: rails-frontend remove-stimulus CONTROLLER_ADI")
      end
      stimulus_sil
    when 'add-layout', 'al'
      @layout_adi = args[1]
      if @layout_adi.nil? || @layout_adi.empty?
        hata_mesaji("Layout adı belirtilmedi. Kullanım: rails-frontend add-layout LAYOUT_ADI")
      end
      layout_ekle
    when 'remove-layout', 'rl'
      @layout_adi = args[1]
      if @layout_adi.nil? || @layout_adi.empty?
        hata_mesaji("Layout adı belirtilmedi. Kullanım: rails-frontend remove-layout LAYOUT_ADI")
      end
      layout_sil
    when 'add-pin', 'pin'
      @pin_adi = args[1]
      if @pin_adi.nil? || @pin_adi.empty?
        hata_mesaji("Pin adı belirtilmedi. Kullanım: rails-frontend add-pin PAKET_ADI")
      end
      pin_ekle
    when 'remove-pin', 'unpin'
      @pin_adi = args[1]
      if @pin_adi.nil? || @pin_adi.empty?
        hata_mesaji("Pin adı belirtilmedi. Kullanım: rails-frontend remove-pin PAKET_ADI")
      end
      pin_sil
    when 'run', 'r'
      server_calistir
    when 'build', 'b'
      build_statik_site
    when 'update', 'u'
      cli_guncelle
    when 'version', '-v', '--version'
      puts "Rails Frontend CLI v#{VERSION}"
      exit 0
    when 'help', '-h', '--help'
      yardim_goster
      exit 0
    else
      hata_mesaji("Bilinmeyen komut: #{@komut}")
    end
  end

  private

  def yeni_proje_olustur
    baslik_goster("Yeni Rails Frontend Projesi Oluşturuluyor: #{@proje_adi}")

    # Rails projesinin zaten var olup olmadığını kontrol et
    if Dir.exist?(@proje_adi)
      hata_mesaji("'#{@proje_adi}' dizini zaten mevcut!")
    end

    # Rails projesi oluştur
    mesaj_goster("Rails projesi oluşturuluyor...")
    
    # Clean mode'a göre komut oluştur
    if @clean_mode
      rails_komut = "rails new #{@proje_adi} --css=tailwind --javascript=importmap " \
                    "--skip-test --skip-system-test --skip-action-mailer " \
                    "--skip-action-mailbox --skip-action-text --skip-active-job " \
                    "--skip-action-cable --skip-active-storage --skip-active-record "\
                    "--skip-solid --skip-kamal --skip-docker"
    else
      rails_komut = "rails new #{@proje_adi} --css=tailwind --javascript=importmap"
    end
    
    unless system(rails_komut)
      hata_mesaji("Rails projesi oluşturulamadı!")
    end
    basari_mesaji("Rails projesi oluşturuldu")

    # Proje dizinine geç
    proje_dizini = File.expand_path(@proje_adi)
    Dir.chdir(proje_dizini) do
      # Gereksiz dosyaları temizle (eğer --clean parametresi varsa)
      if @clean_mode
        mesaj_goster("Gereksiz dosyalar temizleniyor...")
        temizle_gereksiz_dosyalar
        basari_mesaji("Gereksiz dosyalar temizlendi")
      end

      # Home controller ve view oluştur
      mesaj_goster("Home controller ve view oluşturuluyor...")
      olustur_home_controller
      basari_mesaji("Home controller ve view oluşturuldu")

      # Shared componentler oluştur
      mesaj_goster("Shared componentler oluşturuluyor...")
      olustur_shared_componentler
      basari_mesaji("Shared componentler oluşturuldu")

      # CSS dosyaları oluştur
      mesaj_goster("CSS dosyaları oluşturuluyor...")
      olustur_css_dosyalari
      basari_mesaji("CSS dosyaları oluşturuldu")

      # Asset klasörleri oluştur
      mesaj_goster("Asset klasörleri oluşturuluyor...")
      olustur_asset_klasorleri
      basari_mesaji("Asset klasörleri oluşturuldu")

      # Layout dosyasını güncelle
      mesaj_goster("Layout dosyası güncelleniyor...")
      guncelle_layout
      basari_mesaji("Layout dosyası güncellendi")

      # Routes yapılandır
      mesaj_goster("Routes yapılandırılıyor...")
      guncelle_routes('home', 'index', root: true)
      basari_mesaji("Routes yapılandırıldı")

      # Procfile.dev yapılandır
      mesaj_goster("Procfile.dev yapılandırılıyor...")
      guncelle_procfile
      basari_mesaji("Procfile.dev yapılandırıldı")
    end

    tamamlandi_mesaji
  end

  def sayfa_ekle
    # Mevcut dizinin Rails projesi olup olmadığını kontrol et
    rails_projesi_mi?

    baslik_goster("Yeni Sayfa Ekleniyor: #{@sayfa_adi}")

    # Sayfa adını normalize et (türkçe karakterleri değiştir)
    sayfa_adi_normalized = normalize_isim(@sayfa_adi)

    # View oluştur (home klasöründe)
    mesaj_goster("View dosyası oluşturuluyor...")
    olustur_view(sayfa_adi_normalized)
    basari_mesaji("View dosyası oluşturuldu")

    # CSS dosyası oluştur
    mesaj_goster("CSS dosyası oluşturuluyor...")
    olustur_css(sayfa_adi_normalized)
    basari_mesaji("CSS dosyası oluşturuldu")

    # Home controller'a action ekle
    mesaj_goster("Home controller güncelleniyor...")
    home_controller_action_ekle(sayfa_adi_normalized)
    basari_mesaji("Home controller güncellendi")

    # Route ekle
    mesaj_goster("Route ekleniyor...")
    guncelle_routes(sayfa_adi_normalized, sayfa_adi_normalized)
    basari_mesaji("Route eklendi")

    puts "\n #{renklendir('Sayfa başarıyla eklendi!', :yesil)}"
    puts "Sayfa URL: #{renklendir("/#{sayfa_adi_normalized}", :mavi)}"
  end

  def sayfa_sil
    rails_projesi_mi?

    baslik_goster("Sayfa Siliniyor: #{@sayfa_adi}")

    sayfa_adi_normalized = normalize_isim(@sayfa_adi)

    # Home/index sayfasını silmeyi engelle
    if sayfa_adi_normalized == 'home' || sayfa_adi_normalized == 'index'
      hata_mesaji("Ana sayfa (home/index) silinemez!")
    end

    # Dosyaların varlığını kontrol et
    view_path = "app/views/home/#{sayfa_adi_normalized}.html.erb"
    unless File.exist?(view_path)
      hata_mesaji("'#{sayfa_adi_normalized}' sayfası bulunamadı!")
    end

    # Onay al
    print "#{renklendir('Emin misiniz?', :sari)} '#{sayfa_adi_normalized}' sayfası silinecek (e/h): "
    onay = STDIN.gets.chomp.downcase
    unless onay == 'y' || onay == 'yes' || onay == 'e' || onay == 'evet'
      puts "İşlem iptal edildi."
      exit 0
    end

    # View dosyasını sil
    mesaj_goster("View dosyası siliniyor...")
    FileUtils.rm_f(view_path)
    basari_mesaji("View dosyası silindi")

    # CSS dosyasını sil
    mesaj_goster("CSS dosyası siliniyor...")
    FileUtils.rm_f("app/assets/stylesheets/#{sayfa_adi_normalized}.css")
    basari_mesaji("CSS dosyası silindi")

    # Home controller'dan action'ı kaldır
    mesaj_goster("Home controller güncelleniyor...")
    home_controller_action_kaldir(sayfa_adi_normalized)
    basari_mesaji("Home controller güncellendi")

    # Route'u kaldır
    mesaj_goster("Route kaldırılıyor...")
    kaldir_route(sayfa_adi_normalized)
    basari_mesaji("Route kaldırıldı")

    puts "\n #{renklendir('Sayfa başarıyla silindi!', :yesil)}"
  end

  def stimulus_ekle
    # Mevcut dizinin Rails projesi olup olmadığını kontrol et
    rails_projesi_mi?

    baslik_goster("Stimulus Controller Oluşturuluyor: #{@controller_adi}")

    # Controller adını normalize et
    controller_adi_normalized = normalize_isim(@controller_adi)

    # Stimulus controller oluştur
    mesaj_goster("Stimulus controller oluşturuluyor...")
    olustur_stimulus_controller(controller_adi_normalized)
    basari_mesaji("Stimulus controller oluşturuldu")

    puts "\n #{renklendir('Stimulus controller başarıyla oluşturuldu!', :yesil)}"
    puts "Dosya: #{renklendir("app/javascript/controllers/#{controller_adi_normalized}_controller.js", :mavi)}"
  end

  def stimulus_sil
    # Mevcut dizinin Rails projesi olup olmadığını kontrol et
    rails_projesi_mi?

    baslik_goster("Stimulus Controller Siliniyor: #{@controller_adi}")

    # Controller adını normalize et
    controller_adi_normalized = normalize_isim(@controller_adi)
    controller_file = "app/javascript/controllers/#{controller_adi_normalized}_controller.js"

    # Controller dosyasının varlığını kontrol et
    unless File.exist?(controller_file)
      hata_mesaji("Stimulus controller bulunamadı: #{controller_file}")
    end

    # View dosyalarında kullanım kontrolü
    mesaj_goster("View dosyalarında kullanım kontrol ediliyor...")
    kullanilan_dosyalar = []
    
    if Dir.exist?('app/views')
      Dir.glob('app/views/**/*.html.erb').each do |view_file|
        content = File.read(view_file)
        # data-controller="controller_adi" veya data-controller='controller_adi' kontrolü
        if content.match?(/data-controller=["'].*#{controller_adi_normalized}.*["']/)
          kullanilan_dosyalar << view_file
        end
      end
    end

    if kullanilan_dosyalar.any?
      puts "\n"
      puts renklendir("UYARI: Bu controller aşağıdaki dosyalarda kullanılıyor:", :sari, bold: true)
      kullanilan_dosyalar.each do |dosya|
        puts "  - #{dosya}"
      end
      puts "\n"
      print renklendir("Yine de silmek istiyor musunuz? (e/h): ", :sari)
      cevap = STDIN.gets.chomp.downcase
      unless cevap == 'y' || cevap == 'yes' || cevap == 'e' || cevap == 'evet'
        puts "\nİşlem iptal edildi."
        exit 0
      end
    end
    basari_mesaji("Kontrol tamamlandı")

    # Controller'ı sil
    mesaj_goster("Stimulus controller siliniyor...")
    FileUtils.rm_f(controller_file)
    basari_mesaji("Stimulus controller silindi")

    puts "\n #{renklendir('Stimulus controller başarıyla silindi!', :yesil)}"
  end

  def layout_ekle
    # Mevcut dizinin Rails projesi olup olmadığını kontrol et
    rails_projesi_mi?

    baslik_goster("Layout Oluşturuluyor: #{@layout_adi}")

    # Layout adını normalize et
    layout_adi_normalized = normalize_isim(@layout_adi)

    # Layout dosyasının zaten var olup olmadığını kontrol et
    layout_file = "app/views/layouts/#{layout_adi_normalized}.html.erb"
    if File.exist?(layout_file)
      hata_mesaji("Layout zaten mevcut: #{layout_file}")
    end

    # app/views/home klasöründeki dosyaları tara
    mesaj_goster("View dosyaları taranıyor...")
    home_views = home_views_listele
    basari_mesaji("View dosyaları tarandı")

    # Eşleşen view dosyası kontrolü
    view_adi = nil
    if home_views.include?(layout_adi_normalized)
      # Eşleşen view var
      view_adi = layout_adi_normalized
      puts "\n#{renklendir("Eşleşen view dosyası bulundu: #{view_adi}.html.erb", :yesil)}"
    else
      # Eşleşen view yok, kullanıcıya sor
      if home_views.empty?
        hata_mesaji("app/views/home klasöründe view dosyası bulunamadı!")
      end

      puts "\n#{renklendir("Bu layout hangi view ile kullanılacak?", :sari, bold: true)}"
      home_views.each_with_index do |view, index|
        puts "  #{index + 1}. #{view}"
      end
      print "\nSeçim (1-#{home_views.length}): "
      secim = STDIN.gets.chomp.to_i

      if secim < 1 || secim > home_views.length
        hata_mesaji("Geçersiz seçim!")
      end

      view_adi = home_views[secim - 1]
    end

    # Aynı view için mevcut layout kontrolü
    mesaj_goster("Mevcut layout kontrol ediliyor...")
    mevcut_layout = view_icin_mevcut_layout_bul(view_adi)
    if mevcut_layout
      basari_mesaji("Kontrol tamamlandı")
      hata_mesaji("'#{view_adi}' view'i için zaten bir layout tanımlı: '#{mevcut_layout}'\nÖnce mevcut layout'u kaldırın: rails-frontend remove-layout #{mevcut_layout}")
    end
    basari_mesaji("Kontrol tamamlandı")

    # Layout dosyası oluştur
    mesaj_goster("Layout dosyası oluşturuluyor...")
    olustur_layout_dosyasi(layout_adi_normalized)
    basari_mesaji("Layout dosyası oluşturuldu")

    # Controller'a layout direktifi ekle
    mesaj_goster("Home controller güncelleniyor...")
    layout_direktifi_ekle(layout_adi_normalized, view_adi)
    basari_mesaji("Home controller güncellendi")

    puts "\n #{renklendir('Layout başarıyla oluşturuldu!', :yesil)}"
    puts "Layout dosyası: #{renklendir(layout_file, :mavi)}"
    puts "Kullanılacağı view: #{renklendir("#{view_adi}.html.erb", :mavi)}"
  end

  def layout_sil
    # Mevcut dizinin Rails projesi olup olmadığını kontrol et
    rails_projesi_mi?

    baslik_goster("Layout Siliniyor: #{@layout_adi}")

    # Layout adını normalize et
    layout_adi_normalized = normalize_isim(@layout_adi)
    layout_file = "app/views/layouts/#{layout_adi_normalized}.html.erb"

    # Layout dosyasının varlığını kontrol et
    unless File.exist?(layout_file)
      hata_mesaji("Layout bulunamadı: #{layout_file}")
    end

    # Onay iste
    print renklendir("'#{layout_adi_normalized}' layout'unu silmek istediğinizden emin misiniz? (e/h): ", :sari)
    cevap = STDIN.gets.chomp.downcase
    unless cevap == 'y' || cevap == 'yes' || cevap == 'e' || cevap == 'evet'
      puts "\nİşlem iptal edildi."
      exit 0
    end

    # Controller'dan layout direktifini kaldır
    mesaj_goster("Home controller güncelleniyor...")
    layout_direktifi_kaldir(layout_adi_normalized)
    basari_mesaji("Home controller güncellendi")

    # Layout dosyasını sil
    mesaj_goster("Layout dosyası siliniyor...")
    FileUtils.rm_f(layout_file)
    basari_mesaji("Layout dosyası silindi")

    puts "\n #{renklendir('Layout başarıyla silindi!', :yesil)}"
  end

  def pin_ekle
    # Mevcut dizinin Rails projesi olup olmadığını kontrol et
    rails_projesi_mi?

    baslik_goster("Importmap Pin Ekleniyor: #{@pin_adi}")

    # bin/importmap dosyasının varlığını kontrol et
    unless File.exist?('bin/importmap')
      hata_mesaji("bin/importmap bulunamadı! Bu proje importmap kullanmıyor olabilir.")
    end

    # bin/importmap pin komutunu çalıştır
    mesaj_goster("Pin ekleniyor...")
    output = `bin/importmap pin #{@pin_adi} 2>&1`
    
    # Çıktıda hata kontrolü
    if output.include?("Couldn't find") || output.include?("error") || output.include?("Error")
      puts "" # Yeni satır
      hata_mesaji("Pin eklenemedi! Paket bulunamadı: #{@pin_adi}")
    end
    
    basari_mesaji("Pin eklendi")

    puts "\n #{renklendir('Pin başarıyla eklendi!', :yesil)}"
    puts " #{renklendir('Kullanmak için projenize import etmeyi unutmayın!', :yesil)}"
    puts "Paket: #{renklendir(@pin_adi, :mavi)}"
  end

  def pin_sil
    # Mevcut dizinin Rails projesi olup olmadığını kontrol et
    rails_projesi_mi?

    baslik_goster("Importmap Pin Siliniyor: #{@pin_adi}")

    # bin/importmap dosyasının varlığını kontrol et
    unless File.exist?('bin/importmap')
      hata_mesaji("bin/importmap bulunamadı! Bu proje importmap kullanmıyor olabilir.")
    end

    # JavaScript ve HTML dosyalarında kullanım kontrolü
    mesaj_goster("Kullanım kontrol ediliyor...")
    kullanilan_dosyalar = pin_kullanim_kontrol(@pin_adi)
    basari_mesaji("Kontrol tamamlandı")

    if kullanilan_dosyalar.any?
      puts "\n"
      puts renklendir("UYARI: Bu paket aşağıdaki dosyalarda kullanılıyor:", :sari, bold: true)
      kullanilan_dosyalar.each do |dosya|
        puts "  - #{dosya}"
      end
      puts "\n"
      print renklendir("Yine de silmek istiyor musunuz? (e/h): ", :sari)
      cevap = STDIN.gets.chomp.downcase
      unless cevap == 'y' || cevap == 'yes' || cevap == 'e' || cevap == 'evet'
        puts "\nİşlem iptal edildi."
        exit 0
      end
    end

    # Pin'in varlığını kontrol et
    mesaj_goster("Pin kontrol ediliyor...")
    importmap_file = 'config/importmap.rb'
    unless File.exist?(importmap_file)
      hata_mesaji("config/importmap.rb bulunamadı!")
    end
    
    importmap_content = File.read(importmap_file)
    unless importmap_content.match?(/pin\s+["']#{Regexp.escape(@pin_adi)}["']/)
      puts "" # Yeni satır
      hata_mesaji("Pin bulunamadı! '#{@pin_adi}' importmap'te tanımlı değil.")
    end
    basari_mesaji("Pin bulundu")

    # bin/importmap unpin komutunu çalıştır
    mesaj_goster("Pin siliniyor...")
    output = `bin/importmap unpin #{@pin_adi} 2>&1`
    basari_mesaji("Pin silindi")

    puts "\n #{renklendir('Pin başarıyla silindi!', :yesil)}"
  end

  # Helper metodlar
  def rails_projesi_mi?
    unless File.exist?('config/routes.rb') && File.exist?('Gemfile')
      hata_mesaji("Bu dizin bir Rails projesi değil! Lütfen Rails projesi içinde çalıştırın.")
    end
  end

  def server_calistir
    rails_projesi_mi?

    unless File.exist?('bin/dev')
      hata_mesaji("bin/dev dosyası bulunamadı! Bu proje Rails 7+ ile oluşturulmamış olabilir.")
    end

    puts "\n#{renklendir('Rails server başlatılıyor...', :yesil, bold: true)}"
    puts "#{renklendir('Durdurmak için Ctrl+C kullanın', :sari)}\n\n"
    
    exec('bin/dev')
  end

  def cli_guncelle
    baslik_goster("Rails Frontend CLI Güncelleniyor")
    
    # CLI'nin kurulu olduğu dizini bul (symlink'leri takip ederek)
    cli_path = File.dirname(File.realpath(__FILE__))
    
    unless Dir.exist?(File.join(cli_path, '.git'))
      hata_mesaji("Bu CLI git repository'den kurulmamış. Manuel güncelleme gerekiyor.")
    end
    
    puts "CLI dizini: #{renklendir(cli_path, :mavi)}"
    puts ""
    
    # Git dizinine geç
    Dir.chdir(cli_path) do
      # Mevcut branch'i kontrol et
      mesaj_goster("Git durumu kontrol ediliyor...")
      current_branch = `git rev-parse --abbrev-ref HEAD 2>/dev/null`.strip
      
      if current_branch.empty? || current_branch == "HEAD"
        puts ""
        hata_mesaji("Git branch bilgisi alınamadı. Lütfen kurulumu kontrol edin.")
      end
      
      puts "Mevcut branch: #{renklendir(current_branch, :mavi)}"
      basari_mesaji("Kontrol tamamlandı")
      
      # Yerel değişiklik kontrolü
      git_status = `git status --porcelain 2>/dev/null`.strip
      
      unless git_status.empty?
        puts ""
        puts "#{renklendir('⚠', :sari)} Yerel değişiklikler bulundu:"
        puts git_status
        puts ""
        hata_mesaji("Lütfen önce yerel değişikliklerinizi commit edin veya stash'leyin.")
      end
      
      # Güncellemeleri kontrol et
      mesaj_goster("Güncellemeler kontrol ediliyor...")
      system("git fetch origin #{current_branch} 2>&1 > /dev/null")
      
      local_commit = `git rev-parse HEAD 2>/dev/null`.strip
      remote_commit = `git rev-parse origin/#{current_branch} 2>/dev/null`.strip
      
      if local_commit == remote_commit
        basari_mesaji("Kontrol tamamlandı")
        puts "\n#{renklendir('✓', :yesil)} En güncel versiyonu kullanıyorsunuz! (v#{VERSION})"
        puts ""
        return
      end
      
      basari_mesaji("Yeni güncelleme bulundu")
      
      # Güncelleme yap
      mesaj_goster("Güncelleme yapılıyor...")
      output = `git pull origin #{current_branch} 2>&1`
      
      if $?.success?
        basari_mesaji("Güncelleme tamamlandı")
        puts "\n#{renklendir('✓ CLI başarıyla güncellendi!', :yesil)}"
        puts ""
        puts "Değişiklikler bir sonraki komutta aktif olacak."
        puts ""
      else
        puts ""
        hata_mesaji("Güncelleme başarısız oldu!\n#{output}")
      end
    end
  end

  def build_statik_site
    rails_projesi_mi?
    baslik_goster("Statik Dosyalar Oluşturuluyor")

    # Server kontrolü
    mesaj_goster("Server kontrolü...")  
    server = server_kontrol_et
    unless server[:calisiyormu]
      hata_mesaji("Rails server çalışmıyor! Önce 'rails-frontend run' ile başlatın.")
    end
    basari_mesaji("Server çalışıyor")
     
    # Wget ile mirror
    wget_mirror(server[:port])

    # Build klasörü hazırlama
    mesaj_goster("Build klasörü hazırlanıyor...")  
    build_yapilandir
    basari_mesaji("Build klasörü hazırlandı")
    
    # Dosyaları taşı
    mesaj_goster("Dosyalar organize ediliyor...")
    tasi_assets_dosyalari
    basari_mesaji("Dosyalar organize edildi")
    
    # Path düzeltmeleri
    mesaj_goster("Path düzeltmeleri yapılıyor...")
    duzelt_html_pathleri(server[:port])
    duzelt_css_pathleri
    basari_mesaji("Path düzeltmeleri tamamlandı")
    
    # Temizlik
    mesaj_goster("Gerekli olmayan bileşenler kaldırılıyor...")
    temizle_html_dosyalari
    basari_mesaji("Gerekli olmayan bileşenler kaldırıldı")
    
    puts "\n#{renklendir('✓ Statik site başarıyla oluşturuldu!', :yesil)}"
    puts "Klasör: #{renklendir('build/', :mavi)}"
    puts "\nTest etmek için:"
    puts "  cd build && python3 -m http.server 8000 veya npx http-server -p 8000"
  end

  # Build helper metodları
  def server_kontrol_et
    pid_file = 'tmp/pids/server.pid'
    return { calisiyormu: false, port: nil } unless File.exist?(pid_file)

    pid = File.read(pid_file).strip.to_i

    begin
      # Port numarasını bul
      cmd = `ps -p #{pid} -o args=`.strip
      port = cmd[/tcp:\/\/[^:]+:(\d+)/, 1]

      { calisiyormu: true, port: port.to_i }
    rescue Errno::ESRCH, Errno::EPERM
      # Process bulunamadı veya erişim yok
      { calisiyormu: false, port: nil }
    end
  end

  def wget_mirror(port)
    # önceki build klasörünü sil
    FileUtils.rm_rf('build')

    # wget'i sessizce çalıştır
    system("wget --mirror --convert-links --adjust-extension --page-requisites --no-parent --directory-prefix=build http://localhost:#{port}/ > /dev/null 2>&1")
    
    # localhost:3000 klasörünü build/ içine taşı
    if Dir.exist?("build/localhost:#{port}")
      Dir.glob("build/localhost:#{port}/*").each do |file|
        FileUtils.mv(file, 'build/')
      end
      FileUtils.rm_rf("build/localhost:#{port}")
    end
  end

  def build_yapilandir
    ['img', 'js', 'css', 'fonts'].each do |dir|
      FileUtils.mkdir_p("build/assets/#{dir}")
    end
  end

  def tasi_assets_dosyalari
    uzantilar = [ "{jpg,jpeg,png,gif,svg,webp,ico}", "js", "css", "{woff,woff2,ttf,eot,otf}" ]
    dosyalar = [ "img", "js", "css", "fonts" ]

    uzantilar.zip(dosyalar).each do |uzanti, klasor|
      Dir.glob("build/**/*.#{uzanti}").each do |file|
        basename = File.basename(file)
        dest = "build/assets/#{klasor}/#{basename}"

        # Dosya varsa ve hedef yoksa taşı
        if File.exist?(file) && !File.exist?(dest)
          FileUtils.mv(file, dest)
        end
      end
    end

    # controllers klasörü varsa içindekileri taşı ve sil
    if Dir.exist?("build/assets/controllers")
      Dir.glob("build/assets/controllers/*").each do |file|
        FileUtils.mv(file, 'build/assets/js/')
      end
      FileUtils.rm_rf("build/assets/controllers")
    end

    # turbo dosyalarını sil (bu dosya stimulus için gerekli olabilir şimdilik yoruma aldım)
    # Dir.glob('**/*turbo.min*').each do |file|
    #   FileUtils.rm_rf(file)
    # end
  end

  def duzelt_html_pathleri(port)
    Dir.glob('build/**/*.html').each do |file|
      content = File.read(file)
      
      # 1. "assets/" içeren ve .js ile biten satırlara "assets/" den sonra "js/" ekle
      # Örnek: assets/application-bfcdf840.js -> assets/js/application-bfcdf840.js
      content.gsub!(/assets\/([^\/\s"']+\.js)/, 'assets/js/\1')
      
      # 2. "assets/controllers/" içeren ve .js ile biten satırlara "assets/controllers/" den sonra "js/" ekle
      # Örnek: assets/controllers/index-ee64e1f1.js -> assets/js/index-ee64e1f1.js
      content.gsub!(/assets\/controllers\/([^\/\s"']+\.js)/, 'assets/js/\1')
      
      # 3. "assets/" içeren ve .css ile biten satırlara "assets/" den sonra "css/" ekle
      # Örnek: assets/application-72587725.css -> assets/css/application-72587725.css
      content.gsub!(/assets\/([^\/\s"']+\.css)/, 'assets/css/\1')

      # 4. "assets/" içeren ve .jpg|jpeg|png|gif|svg|webp ile biten satırlara "assets/" den sonra "img/" ekle
      # Örnek: assets/app-image-72587725.jpg -> assets/img/app-image-72587725.jpg
      content.gsub!(/assets\/([^\/\s"']+\.(jpg|jpeg|png|gif|svg|webp))/, 'assets/img/\1')
      content.gsub!(/http:\/\/localhost:#{port}\/([^\/\s"']+\.(jpg|jpeg|png|gif|svg|webp))/, 'assets/img/\1')
      
      File.write(file, content)
    end
  end

  def duzelt_css_pathleri
    Dir.glob('build/assets/css/**/*.css').each do |file|
      content = File.read(file)
      
      # Font paths - absolute path kullan
      # Örnek: url("LavishlyYours-Regular-c6da7860.ttf") -> url("/assets/fonts/LavishlyYours-Regular-c6da7860.ttf")
      content.gsub!(/url\(["']?([^\/][^"'()]*\.(woff2?|ttf|eot|otf))["']?\)/, 'url("/assets/fonts/\1")')
      
      # Image paths - absolute path kullan
      # Örnek: url("A-13904566-1761601378-8017-2b819c09.jpg") -> url("/assets/img/A-13904566-1761601378-8017-2b819c09.jpg")
      content.gsub!(/url\(["']?([^\/][^"'()]*\.(jpg|jpeg|png|gif|svg|webp))["']?\)/, 'url("/assets/img/\1")')
      
      File.write(file, content)
    end
  end

  def temizle_html_dosyalari
    Dir.glob('build/**/*.html').each do |file|
      content = File.read(file)
      
      # index.html linkleri
      content.gsub!(/href="[^"]*\/index\.html"/, 'href="/"')
      content.gsub!(/href="index\.html"/, 'href="/"')
      
      # Turbo kaldır (bu dosya stimulus için gerekli olabilir şimdilik yoruma aldım)
      # content.gsub!(/^.*turbo\.min.*$\n?/, '')
      
      # CSRF kaldır
      content.gsub!(/<meta name="csrf-param"[^>]*>/, '')
      content.gsub!(/<meta name="csrf-token"[^>]*>/, '')
      
      File.write(file, content)
    end
  end

  # Helper metodlar
  def home_controller_action_ekle(sayfa_adi)
    controller_path = 'app/controllers/home_controller.rb'
    return unless File.exist?(controller_path)

    # Küçük bir gecikme ekle (ardı ardına işlemler için) 
    sleep(0.1)

    controller_content = File.read(controller_path)
    
    # Action zaten varsa ekleme - kelime sınırı ile kontrol et
    # "def urunle" ve "def urunler" ayrı ayrı algılansın
    return if controller_content.match?(/^\s*def\s+#{Regexp.escape(sayfa_adi)}\s*$/)

    # Class tanımını bul ve son end'den önce ekle
    lines = controller_content.split("\n")
    
    # Son end satırının index'ini bul
    last_end_index = lines.rindex { |line| line.strip == 'end' }
    
    if last_end_index
      # Yeni action'ı son end'den önce ekle
      new_action_lines = [
        "  def #{sayfa_adi}",
        "  end",
        ""
      ]
      
      lines.insert(last_end_index, *new_action_lines)
      controller_content = lines.join("\n")
      File.write(controller_path, controller_content)
    end
  end

  def home_controller_action_kaldir(sayfa_adi)
    controller_path = 'app/controllers/home_controller.rb'
    return unless File.exist?(controller_path)

    controller_content = File.read(controller_path)
    
    # Action'ı kaldır
    # "  def sayfa_adi" ile başlayan ve "  end" ile biten bloğu bul
    controller_content.gsub!(/^\s*def #{Regexp.escape(sayfa_adi)}\s*$.*?^\s*end\s*$/m, '')
    
    # Fazla boş satırları temizle (3'ten fazla ardışık boş satır varsa 2'ye düşür)
    controller_content.gsub!(/\n{3,}/, "\n\n")

    File.write(controller_path, controller_content)
  end

  def temizle_gereksiz_dosyalar
    # Frontend için gereksiz dosya ve klasörleri sil
    gereksiz_dosyalar = [
      '.github',
      'app/models',
      'app/javascript/controllers/hello_controller.js',
      'config/environments/production.rb',
      'config/environments/test.rb',
      'lib',
      'public',
      'script'
    ]

    gereksiz_dosyalar.each do |dosya|
      # Mevcut olmayan klasör silme işlemi hata üretmesin
      FileUtils.rm_rf(dosya) if File.exist?(dosya) || Dir.exist?(dosya)
    end
  end

  def normalize_isim(isim)
    # Türkçe karakterleri değiştir ve küçük harfe çevir
    tr_map = {
      'ç' => 'c', 'Ç' => 'c',
      'ğ' => 'g', 'Ğ' => 'g',
      'ı' => 'i', 'İ' => 'i',
      'ö' => 'o', 'Ö' => 'o',
      'ş' => 's', 'Ş' => 's',
      'ü' => 'u', 'Ü' => 'u'
    }
    
    normalized = isim.downcase
    tr_map.each { |tr, en| normalized.gsub!(tr, en) }
    normalized.gsub(/[^a-z0-9_]/, '_')
  end

  def uygulama_ismi_al
    # config/application.rb dosyasından uygulama ismini oku
    app_config_path = 'config/application.rb'
    if File.exist?(app_config_path)
      content = File.read(app_config_path)
      # "module UygulamaIsmi" pattern'ini ara
      match = content.match(/module\s+([A-Z][a-zA-Z0-9_]*)/)
      if match
        # CamelCase'i başlık haline çevir (örn: MyApp -> My App)
        return match[1].gsub(/([A-Z]+)([A-Z][a-z])/, '\1 \2')
                      .gsub(/([a-z\d])([A-Z])/, '\1 \2')
      end
    end
    
    # Fallback: Mevcut dizin ismini kullan
    File.basename(Dir.pwd).split('_').map(&:capitalize).join(' ')
  end

  def olustur_home_controller
    controller_content = <<~RUBY
      class HomeController < ApplicationController
        def index
        end
      end
    RUBY

    FileUtils.mkdir_p('app/controllers')
    File.write('app/controllers/home_controller.rb', controller_content)

    # View klasörü ve dosyası oluştur
    FileUtils.mkdir_p('app/views/home')
    view_content = <<~HTML
      <div>
        <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
          <div class="container mx-auto px-4 py-16">
            <div class="text-center">
              <h1 class="text-5xl font-bold text-gray-900 mb-4">
                Hoş Geldiniz! 👋
              </h1>
              <p class="text-xl text-gray-600 mb-8">
                Rails Frontend CLI ile oluşturuldu
              </p>
              <div class="inline-block bg-white rounded-lg shadow-lg p-8">
                <p class="text-gray-700 mb-4">
                  Projeniz başarıyla oluşturuldu ve kullanıma hazır!
                </p>
                <p class="text-sm text-gray-500">
                  Tailwind CSS ve Stimulus ile geliştirmeye başlayabilirsiniz.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    HTML

    File.write('app/views/home/index.html.erb', view_content)
  end

  def olustur_shared_componentler
    FileUtils.mkdir_p('app/views/shared')

    # Header
    header_content = <<~HTML
      <header class="bg-white shadow-sm">
        <div class="container mx-auto px-4 py-4">
          <div class="flex items-center justify-between">
            <div class="text-2xl font-bold text-indigo-600">
              Logo
            </div>
            <%= render 'shared/navbar' %>
          </div>
        </div>
      </header>
    HTML
    File.write('app/views/shared/_header.html.erb', header_content)

    # Navbar
    navbar_content = <<~HTML
      <nav class="hidden md:flex space-x-6">
        <%= link_to "Ana Sayfa", root_path, class: "text-gray-700 hover:text-indigo-600 transition" %>
        <!-- Diğer menü öğeleri buraya eklenecek -->
      </nav>
    HTML
    File.write('app/views/shared/_navbar.html.erb', navbar_content)

    # Footer - Basit ve tam genişlikte
    footer_content = <<~HTML
      <footer class="bg-gray-800 text-white py-6 text-center">
        <p class="text-gray-400">
          © <%= Time.current.year %> Tüm hakları saklıdır.
        </p>
      </footer>
    HTML
    File.write('app/views/shared/_footer.html.erb', footer_content)
  end

  def olustur_css_dosyalari
    FileUtils.mkdir_p('app/assets/stylesheets')

    # Home CSS
    home_css = <<~CSS
      /* Home sayfası özel stilleri */
      .home-container {
        /* Buraya home sayfası için özel stiller eklenebilir */
      }
    CSS
    File.write('app/assets/stylesheets/home.css', home_css)

    # Header CSS
    header_css = <<~CSS
      /* Header özel stilleri */
      header {
        /* Buraya header için özel stiller eklenebilir */
      }
    CSS
    File.write('app/assets/stylesheets/header.css', header_css)

    # Navbar CSS
    navbar_css = <<~CSS
      /* Navbar özel stilleri */
      nav {
        /* Buraya navbar için özel stiller eklenebilir */
      }
    CSS
    File.write('app/assets/stylesheets/navbar.css', navbar_css)

    # Footer CSS
    footer_css = <<~CSS
      /* Footer özel stilleri */
      footer {
        /* Buraya footer için özel stiller eklenebilir */
      }
    CSS
    File.write('app/assets/stylesheets/footer.css', footer_css)
  end

  def olustur_stimulus_controller(sayfa_adi)
    FileUtils.mkdir_p('app/javascript/controllers')

    controller_content = <<~JS
      import { Controller } from "@hotwired/stimulus"

      // #{sayfa_adi.capitalize} sayfası için Stimulus controller
      export default class extends Controller {
        connect() {
          console.log("#{sayfa_adi.capitalize} controller bağlandı")
        }

        disconnect() {
          console.log("#{sayfa_adi.capitalize} controller bağlantısı kesildi")
        }

        // Buraya özel metodlar eklenebilir
      }
    JS

    File.write("app/javascript/controllers/#{sayfa_adi}_controller.js", controller_content)
  end

  def olustur_asset_klasorleri
    # Images klasörü
    FileUtils.mkdir_p('app/assets/images')
    File.write('app/assets/images/.keep', '')

    # Fonts klasörü
    FileUtils.mkdir_p('app/assets/fonts')
    File.write('app/assets/fonts/.keep', '')
  end

  def guncelle_layout
    layout_path = 'app/views/layouts/application.html.erb'
    return unless File.exist?(layout_path)

    layout_content = File.read(layout_path)

    # UTF-8 charset meta tag'ini ekle (eğer yoksa)
    if !layout_content.match?(/<meta\s+charset\s*=\s*["']utf-8["']/i)
      layout_content.gsub!(/<\/title>/) do
        <<~HTML.chomp
          </title>
              <meta charset="utf-8">
        HTML
      end
    end

    # Önce mevcut main tag'lerini temizle
    layout_content.gsub!(/<main[^>]*>/, '')
    layout_content.gsub!(/<\/main>/, '')

    # Body içine shared componentleri ekle
    if layout_content.include?('<body>')
      yeni_layout = layout_content.gsub(/<body>/) do
        <<~HTML.chomp
          <body>
            <%= render 'shared/header' %>
            <main class="min-h-screen">
        HTML
      end

      # Yield'den sonra footer ekle
      yeni_layout = yeni_layout.gsub(/\s*<%= yield %>/) do
        <<~HTML.chomp
          <%= yield %>
            </main>
            <%= render 'shared/footer' %>
        HTML
      end

      File.write(layout_path, yeni_layout)
    end
  end

  def guncelle_routes(sayfa_adi, action, root: false)
    routes_path = 'config/routes.rb'
    routes_content = File.read(routes_path)

    if root
      # Root route ekle
      yeni_route = "  root \"home##{action}\"\n"
      
      # Mevcut root route varsa değiştir, yoksa ekle
      if routes_content.match?(/^\s*root/)
        routes_content.gsub!(/^\s*root.*$/, yeni_route.strip)
      else
        routes_content.gsub!(/Rails\.application\.routes\.draw do\n/) do |match|
          "#{match}#{yeni_route}"
        end
      end
    else
      # Normal route ekle (home controller kullan)
      yeni_route = "  get \"/#{sayfa_adi}\", to: \"home##{action}\"\n"
      
      # Route zaten varsa ekleme
      unless routes_content.include?(yeni_route.strip)
        routes_content.gsub!(/Rails\.application\.routes\.draw do\n/) do |match|
          "#{match}#{yeni_route}"
        end
      end
    end

    File.write(routes_path, routes_content)
  end

  def kaldir_route(sayfa_adi)
    routes_path = 'config/routes.rb'
    routes_content = File.read(routes_path)

    # Route satırını kaldır
    routes_content.gsub!(/^\s*get\s+['"]\/#{sayfa_adi}['"].*\n/, '')

    File.write(routes_path, routes_content)
  end

  def olustur_controller(sayfa_adi)
    controller_content = <<~RUBY
      class #{sayfa_adi.capitalize}Controller < ApplicationController
        def index
        end
      end
    RUBY

    File.write("app/controllers/#{sayfa_adi}_controller.rb", controller_content)
  end

  def olustur_view(sayfa_adi)
    # Home klasöründe view oluştur
    FileUtils.mkdir_p("app/views/home")

    view_content = <<~HTML
      <div>
        <div class="container mx-auto px-4 py-16">
          <h1 class="text-4xl font-bold text-gray-900 mb-4">
            #{sayfa_adi.capitalize}
          </h1>
          <p class="text-gray-600">
            #{sayfa_adi.capitalize} sayfası içeriği buraya gelecek.
          </p>
        </div>
      </div>
    HTML

    File.write("app/views/home/#{sayfa_adi}.html.erb", view_content)
  end

  def olustur_css(sayfa_adi)
    css_content = <<~CSS
      /* #{sayfa_adi.capitalize} sayfası özel stilleri */
      .#{sayfa_adi}-container {
        /* Buraya #{sayfa_adi} sayfası için özel stiller eklenebilir */
      }
    CSS

    File.write("app/assets/stylesheets/#{sayfa_adi}.css", css_content)
  end

  def guncelle_procfile
    procfile_path = 'Procfile.dev'
    
    procfile_content = <<~PROCFILE
      web: bin/rails server -b 0.0.0.0
      css: bin/rails tailwindcss:watch
    PROCFILE
    
    File.write(procfile_path, procfile_content)
  end

  def home_views_listele
    views = []
    if Dir.exist?('app/views/home')
      Dir.glob('app/views/home/*.html.erb').each do |file|
        basename = File.basename(file, '.html.erb')
        # index'i hariç tut
        views << basename unless basename == 'index'
      end
    end
    views.sort
  end

  def olustur_layout_dosyasi(layout_adi)
    FileUtils.mkdir_p('app/views/layouts')
    
    layout_content = <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <title><%= content_for(:title) || "#{layout_adi.capitalize}" %></title>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width,initial-scale=1">
          <meta name="apple-mobile-web-app-capable" content="yes">
          <meta name="application-name" content="#{uygulama_ismi_al}">
          <meta name="mobile-web-app-capable" content="yes">
          <%= yield :head %>
          <%= stylesheet_link_tag :app, "data-turbo-track": "reload" %>
          <%= javascript_importmap_tags %>
        </head>

        <body>
          <main>
            <%= yield %>
          </main>
        </body>
      </html>
    HTML

    File.write("app/views/layouts/#{layout_adi}.html.erb", layout_content)
  end

  def layout_direktifi_ekle(layout_adi, view_adi)
    controller_file = 'app/controllers/home_controller.rb'
    unless File.exist?(controller_file)
      hata_mesaji("Home controller bulunamadı: #{controller_file}")
    end

    controller_content = File.read(controller_file)
    
    # Layout direktifi zaten var mı kontrol et
    if controller_content.match?(/layout\s+["']#{layout_adi}["']/)
      puts "\n#{renklendir("UYARI: Bu layout direktifi zaten mevcut!", :sari)}"
      return
    end

    # Class tanımından sonra layout direktifini ekle
    layout_line = "  layout \"#{layout_adi}\", only: :#{view_adi}\n"
    
    if controller_content.match?(/class\s+HomeController\s*<\s*ApplicationController\s*\n/)
      controller_content.sub!(/class\s+HomeController\s*<\s*ApplicationController\s*\n/) do |match|
        "#{match}#{layout_line}\n"
      end
    else
      hata_mesaji("HomeController class tanımı bulunamadı!")
    end

    File.write(controller_file, controller_content)
  end

  def layout_direktifi_kaldir(layout_adi)
    controller_file = 'app/controllers/home_controller.rb'
    unless File.exist?(controller_file)
      hata_mesaji("Home controller bulunamadı: #{controller_file}")
    end

    controller_content = File.read(controller_file)
    
    # Layout direktifini bul ve kaldır
    controller_content.gsub!(/^\s*layout\s+["']#{layout_adi}["'].*\n/, '')
    
    File.write(controller_file, controller_content)
  end

  def view_icin_mevcut_layout_bul(view_adi)
    controller_file = 'app/controllers/home_controller.rb'
    return nil unless File.exist?(controller_file)

    controller_content = File.read(controller_file)
    
    # layout "layout_adi", only: :view_adi pattern'ini ara
    match = controller_content.match(/layout\s+["']([^"']+)["'].*only:\s*:#{view_adi}\b/)
    match ? match[1] : nil
  end

  def pin_kullanim_kontrol(pin_adi)
    kullanilan_dosyalar = []
    
    # JavaScript dosyalarında ara
    if Dir.exist?('app/javascript')
      Dir.glob('app/javascript/**/*.js').each do |file|
        content = File.read(file)
        # import veya from ile tam eşleşme kontrolü
        # Örnek: from "alpinejs" veya import "chart.js" veya import Alpine from "alpinejs"
        if content.match?(/from\s+["']#{Regexp.escape(pin_adi)}["']/) || 
           content.match?(/import\s+["']#{Regexp.escape(pin_adi)}["']/) ||
           content.match?(/import\s+.+\s+from\s+["']#{Regexp.escape(pin_adi)}["']/)
          kullanilan_dosyalar << file
        end
      end
    end
    
    # HTML/ERB dosyalarında ara
    if Dir.exist?('app/views')
      Dir.glob('app/views/**/*.html.erb').each do |file|
        content = File.read(file)
        # script tag içinde veya importmap içinde tam eşleşme kontrolü
        # Tırnak içinde tam eşleşme arıyoruz
        if content.match?(/["']#{Regexp.escape(pin_adi)}["']/)
          kullanilan_dosyalar << file
        end
      end
    end
    
    kullanilan_dosyalar.uniq
  end

  # Mesaj metodları
  def baslik_goster(mesaj)
    puts renklendir(mesaj, :mavi, bold: true)
  end

  def mesaj_goster(mesaj)
    # Sadece mesajı göster, numara gösterme
    print "  #{mesaj} "
  end

  def basari_mesaji(mesaj)
    puts renklendir('OK', :yesil)
  end

  def hata_mesaji(mesaj)
    puts "\n#{renklendir('HATA:', :kirmizi)} #{mesaj}\n"
    exit 1
  end

  def tamamlandi_mesaji
    puts renklendir("Proje başarıyla oluşturuldu!", :yesil, bold: true)
    puts "\n#{renklendir('Sonraki adımlar:', :mavi)}"
    puts "  1. cd #{@proje_adi}"
    puts "  2. rails-frontend run"
    puts "  3. Tarayıcıda http://localhost:3000 adresini açın"
    puts "\n#{renklendir('Yardım için:', :mavi)}"
    puts "  rails-frontend --help"
    puts ""
  end

  def yardim_goster
    baslik_goster("Rails Frontend CLI v#{VERSION}")
    
    puts renklendir("Frontend geliştiriciler için Rails proje yönetim aracı", :mavi)
    puts ""
    puts renklendir("KULLANIM:", :sari, bold: true)
    puts "  rails-frontend KOMUT [PARAMETRELER]"
    puts ""
    
    puts renklendir("KOMUTLAR:", :sari, bold: true)
    puts <<~KOMUTLAR
      Proje Yönetimi:
        new, n PROJE_ADI [--clean]  Yeni Rails frontend projesi oluştur
        build, b                    Statik site oluştur
        run, r                      Server başlat (bin/dev)
        
      Sayfa Yönetimi:
        add-page, ap SAYFA_ADI      Yeni sayfa ekle (view + CSS + route)
        remove-page, rp SAYFA_ADI   Sayfa sil
        
      Stimulus Controller:
        add-stimulus, as CONTROLLER Stimulus controller ekle
        remove-stimulus, rs CONTROLLER Stimulus controller sil (kullanım kontrolü yapar)
        
      Layout Yönetimi:
        add-layout, al LAYOUT_ADI   Layout ekle (view eşleştirme ile)
        remove-layout, rl LAYOUT_ADI Layout sil
        
      JavaScript Kütüphaneleri:
        add-pin, pin PAKET_ADI      Harici JavaScript kütüphanesi ekle
        remove-pin, unpin PAKET_ADI Harici JavaScript kütüphanesi sil (kullanım kontrolü yapar)
        
      Bilgi:
        update, u                   CLI'yi güncelle (git pull)
        version, -v, --version      Versiyon bilgisi göster
        help, -h, --help            Bu yardım mesajını göster
    KOMUTLAR
    
    puts renklendir("SEÇENEKLER:", :sari, bold: true)
    puts "  --clean                     Frontend için gereksiz dosyaları temizle"
    puts "                              (test, mailers, jobs, channels, models vb.)"
    puts ""
    
    puts renklendir("ÖRNEKLER:", :sari, bold: true)
    puts <<~ORNEKLER
      Yeni proje oluştur:
        rails-frontend new blog --clean
        
      Sayfa ekle:
        rails-frontend add-page hakkımızda
        
      Layout ekle:
        rails-frontend add-layout iletisim
        
      JavaScript kütüphanesi ekle:
        rails-frontend add-pin sweetalert2
        
      Stimulus controller ekle:
        rails-frontend add-stimulus dropdown
        
      Server başlat:
        rails-frontend run
    ORNEKLER
    
    puts renklendir("DAHA FAZLA BİLGİ:", :mavi)
    puts "  Detaylı kullanım kılavuzu: KULLANIM_KILAVUZU.md"
    puts "  GitHub: https://github.com/ozbilgic/rails-frontend-cli"
    puts ""
  end

  def renklendir(metin, renk, bold: false)
    renkler = {
      kirmizi: 31,
      yesil: 32,
      sari: 33,
      mavi: 34,
      magenta: 35,
      cyan: 36
    }

    renk_kodu = renkler[renk] || 37
    bold_kodu = bold ? '1;' : ''
    
    "\e[#{bold_kodu}#{renk_kodu}m#{metin}\e[0m"
  end
end

# Script olarak çalıştırıldığında
if __FILE__ == $0
  cli = RailsFrontendCLI.new
  cli.calistir(ARGV)
end
