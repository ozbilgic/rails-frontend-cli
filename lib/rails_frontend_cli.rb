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
    @project_name = nil
    @page_name = nil
    @command = nil
    @clean_mode = false
  end

  def run(args)
    if args.empty?
      show_help
      exit 0
    end

    @command = args[0]

    case @command
    when 'new', 'n'
      @project_name = args[1]
      if @project_name.nil? || @project_name.empty?
        error_message("Project name not specified. Usage: rails-frontend new PROJECT_NAME [--clean]")
      end
      # Check for --clean parameter
      @clean_mode = args.include?('--clean')
      create_new_project
    when 'add-page', 'ap'
      @page_name = args[1]
      if @page_name.nil? || @page_name.empty?
        error_message("Page name not specified. Usage: rails-frontend add-page PAGE_NAME")
      end
      add_page
    when 'remove-page', 'rp'
      @page_name = args[1]
      if @page_name.nil? || @page_name.empty?
        error_message("Page name not specified. Usage: rails-frontend remove-page PAGE_NAME")
      end
      remove_page
    when 'add-stimulus', 'as'
      @controller_name = args[1]
      if @controller_name.nil? || @controller_name.empty?
        error_message("Controller name not specified. Usage: rails-frontend add-stimulus CONTROLLER_NAME")
      end
      add_stimulus
    when 'remove-stimulus', 'rs'
      @controller_name = args[1]
      if @controller_name.nil? || @controller_name.empty?
        error_message("Controller name not specified. Usage: rails-frontend remove-stimulus CONTROLLER_NAME")
      end
      remove_stimulus
    when 'add-layout', 'al'
      @layout_name = args[1]
      if @layout_name.nil? || @layout_name.empty?
        error_message("Layout name not specified. Usage: rails-frontend add-layout LAYOUT_NAME")
      end
      add_layout
    when 'remove-layout', 'rl'
      @layout_name = args[1]
      if @layout_name.nil? || @layout_name.empty?
        error_message("Layout name not specified. Usage: rails-frontend remove-layout LAYOUT_NAME")
      end
      remove_layout
    when 'add-pin', 'pin'
      @pin_name = args[1]
      if @pin_name.nil? || @pin_name.empty?
        error_message("Pin name not specified. Usage: rails-frontend add-pin PACKAGE_NAME")
      end
      add_pin
    when 'remove-pin', 'unpin'
      @pin_name = args[1]
      if @pin_name.nil? || @pin_name.empty?
        error_message("Pin name not specified. Usage: rails-frontend remove-pin PACKAGE_NAME")
      end
      remove_pin
    when 'run', 'r'
      run_server
    when 'build', 'b'
      build_static_site
    when 'version', '-v', '--version'
      puts "Rails Frontend CLI v#{VERSION}"
      exit 0
    when 'help', '-h', '--help'
      show_help
      exit 0
    else
      error_message("Unknown command: #{@command}")
    end
  end

  private

  def create_new_project
    show_title("Creating New Rails Frontend Project: #{@project_name}")

    # Check if Rails project already exists
    if Dir.exist?(@project_name)
      error_message("'#{@project_name}' directory already exists!")
    end

    # Create Rails project
    show_message("Creating Rails project...")
    
    # Build command based on clean mode
    if @clean_mode
      rails_command = "rails new #{@project_name} --css=tailwind --javascript=importmap " \
                    "--skip-test --skip-system-test --skip-action-mailer " \
                    "--skip-action-mailbox --skip-action-text --skip-active-job " \
                    "--skip-action-cable --skip-active-storage --skip-active-record "\
                    "--skip-solid --skip-kamal --skip-docker"
    else
      rails_command = "rails new #{@project_name} --css=tailwind --javascript=importmap"
    end
    
    unless system(rails_command)
      error_message("Failed to create Rails project!")
    end
    success_message("Rails project created")

    # Change to project directory
    project_directory = File.expand_path(@project_name)
    Dir.chdir(project_directory) do
      # Clean unnecessary files (if --clean parameter exists)
      if @clean_mode
        show_message("Cleaning unnecessary files...")
        clean_unnecessary_files
        success_message("Unnecessary files cleaned")
      end

      # Create Home controller and view
      show_message("Creating Home controller and view...")
      create_home_controller
      success_message("Home controller and view created")

      # Create shared components
      show_message("Creating shared components...")
      create_shared_components
      success_message("Shared components created")

      # Create CSS files
      show_message("Creating CSS files...")
      create_css_files
      success_message("CSS files created")

      # Create asset folders
      show_message("Creating asset folders...")
      create_asset_folders
      success_message("Asset folders created")

      # Update layout file
      show_message("Updating layout file...")
      update_layout
      success_message("Layout file updated")

      # Configure routes
      show_message("Configuring routes...")
      update_routes('home', 'index', root: true)
      success_message("Routes configured")

      # Configure Procfile.dev
      show_message("Configuring Procfile.dev...")
      update_procfile
      success_message("Procfile.dev configured")
    end

    completion_message
  end

  def add_page
    # Check if current directory is a Rails project
    is_rails_project?

    show_title("Adding New Page: #{@page_name}")

    # Normalize page name (convert Turkish characters)
    page_name_normalized = normalize_name(@page_name)

    # Create view (in home folder)
    show_message("Creating view file...")
    create_view(page_name_normalized)
    success_message("View file created")

    # Create CSS file
    show_message("Creating CSS file...")
    create_css(page_name_normalized)
    success_message("CSS file created")

    # Add action to Home controller
    show_message("Updating Home controller...")
    add_home_controller_action(page_name_normalized)
    success_message("Home controller updated")

    # Add route
    show_message("Adding route...")
    update_routes(page_name_normalized, page_name_normalized)
    success_message("Route added")

    puts "\n #{colorize('Page successfully added!', :green)}"
    puts "Page URL: #{colorize("/#{page_name_normalized}", :blue)}"
  end

  def remove_page
    is_rails_project?

    show_title("Removing Page: #{@page_name}")

    page_name_normalized = normalize_name(@page_name)

    # Prevent deletion of home/index page
    if page_name_normalized == 'home' || page_name_normalized == 'index'
      error_message("Home page (home/index) cannot be deleted!")
    end

    # Check file existence
    view_path = "app/views/home/#{page_name_normalized}.html.erb"
    unless File.exist?(view_path)
      error_message("'#{page_name_normalized}' page not found!")
    end

    # Get confirmation
    print "#{colorize('Are you sure?', :yellow)} '#{page_name_normalized}' page will be deleted (y/n): "
    confirmation = STDIN.gets.chomp.downcase
    unless confirmation == 'y' || confirmation == 'yes'
      puts "Operation cancelled."
      exit 0
    end

    # Delete view file
    show_message("Deleting view file...")
    FileUtils.rm_f(view_path)
    success_message("View file deleted")

    # Delete CSS file
    show_message("Deleting CSS file...")
    FileUtils.rm_f("app/assets/stylesheets/#{page_name_normalized}.css")
    success_message("CSS file deleted")

    # Remove action from Home controller
    show_message("Updating Home controller...")
    remove_home_controller_action(page_name_normalized)
    success_message("Home controller updated")

    # Remove route
    show_message("Removing route...")
    remove_route(page_name_normalized)
    success_message("Route removed")

    puts "\n #{colorize('Page successfully deleted!', :green)}"
  end

  def add_stimulus
    # Check if current directory is a Rails project
    is_rails_project?

    show_title("Creating Stimulus Controller: #{@controller_name}")

    # Normalize controller name
    controller_name_normalized = normalize_name(@controller_name)
    controller_file = "app/javascript/controllers/#{controller_name_normalized}_controller.js"

    # Check if controller file already exists
    if File.exist?(controller_file)
      error_message("Stimulus controller already exists: #{controller_file}")
    end

    # Create Stimulus controller
    show_message("Creating Stimulus controller...")
    create_stimulus_controller(controller_name_normalized)
    success_message("Stimulus controller created")

    puts "\n #{colorize('Stimulus controller successfully created!', :green)}"
    puts "File: #{colorize("app/javascript/controllers/#{controller_name_normalized}_controller.js", :blue)}"
  end

  def remove_stimulus
    # Check if current directory is a Rails project
    is_rails_project?

    show_title("Removing Stimulus Controller: #{@controller_name}")

    # Normalize controller name
    controller_name_normalized = normalize_name(@controller_name)
    controller_file = "app/javascript/controllers/#{controller_name_normalized}_controller.js"

    # Check controller file existence
    unless File.exist?(controller_file)
      error_message("Stimulus controller not found: #{controller_file}")
    end

    # Check usage in view files
    show_message("Checking usage in view files...")
    used_files = []
    
    if Dir.exist?('app/views')
      Dir.glob('app/views/**/*.html.erb').each do |view_file|
        content = File.read(view_file)
        # Check for data-controller="controller_name" or data-controller='controller_name'
        # Also check for data: { controller: "controller_name" } pattern
        if content.match?(/data-controller=["'].*#{controller_name_normalized}.*["']/) ||
           content.match?(/data:\s*\{[^}]*controller:\s*["']#{controller_name_normalized}["'][^}]*\}/)
          used_files << view_file
        end
      end
    end

    if used_files.any?
      puts "\n"
      puts colorize("WARNING: This controller is being used in the following files:", :yellow, bold: true)
      used_files.each do |file|
        puts "  - #{file}"
      end
      puts "\n"
      print colorize("Do you still want to delete it? (y/n): ", :yellow)
      answer = STDIN.gets.chomp.downcase
      unless answer == 'y' || answer == 'yes'
        puts "\nOperation cancelled."
        exit 0
      end
    end
    success_message("Check completed")

    # Delete controller
    show_message("Deleting Stimulus controller...")
    FileUtils.rm_f(controller_file)
    success_message("Stimulus controller deleted")

    puts "\n #{colorize('Stimulus controller successfully deleted!', :green)}"
  end

  def add_layout
    # Check if current directory is a Rails project
    is_rails_project?

    show_title("Creating Layout: #{@layout_name}")

    # Normalize layout name
    layout_name_normalized = normalize_name(@layout_name)

    # Check if layout file already exists
    layout_file = "app/views/layouts/#{layout_name_normalized}.html.erb"
    if File.exist?(layout_file)
      error_message("Layout already exists: #{layout_file}")
    end

    # Scan files in app/views/home folder
    show_message("Scanning view files...")
    home_views = list_home_views
    success_message("View files scanned")

    # Check for matching view file
    view_name = nil
    if home_views.include?(layout_name_normalized)
      # Matching view exists
      view_name = layout_name_normalized
      puts "\n#{colorize("Matching view file found: #{view_name}.html.erb", :green)}"
    else
      # No matching view, ask user
      if home_views.empty?
        error_message("No view files found in app/views/home folder!")
      end

      puts "\n#{colorize("Which view will this layout be used with?", :yellow, bold: true)}"
      home_views.each_with_index do |view, index|
        puts "  #{index + 1}. #{view}"
      end
      print "\nChoice (1-#{home_views.length}): "
      choice = STDIN.gets.chomp.to_i

      if choice < 1 || choice > home_views.length
        error_message("Invalid choice!")
      end

      view_name = home_views[choice - 1]
    end

    # Check for existing layout for the same view
    show_message("Checking for existing layout...")
    existing_layout = find_existing_layout_for_view(view_name)
    if existing_layout
      success_message("Check completed")
      error_message("A layout is already defined for '#{view_name}' view: '#{existing_layout}'\nRemove the existing layout first: rails-frontend remove-layout #{existing_layout}")
    end
    success_message("Check completed")

    # Create layout file
    show_message("Creating layout file...")
    create_layout_file(layout_name_normalized)
    success_message("Layout file created")

    # Add layout directive to controller
    show_message("Updating Home controller...")
    add_layout_directive(layout_name_normalized, view_name)
    success_message("Home controller updated")

    puts "\n #{colorize('Layout successfully created!', :green)}"
    puts "Layout file: #{colorize(layout_file, :blue)}"
    puts "Will be used for view: #{colorize("#{view_name}.html.erb", :blue)}"
  end

  def remove_layout
    # Check if current directory is a Rails project
    is_rails_project?

    show_title("Removing Layout: #{@layout_name}")

    # Normalize layout name
    layout_name_normalized = normalize_name(@layout_name)
    layout_file = "app/views/layouts/#{layout_name_normalized}.html.erb"

    # Check layout file existence
    unless File.exist?(layout_file)
      error_message("Layout not found: #{layout_file}")
    end

    # Request confirmation
    print colorize("Are you sure you want to delete '#{layout_name_normalized}' layout? (y/n): ", :yellow)
    answer = STDIN.gets.chomp.downcase
    unless answer == 'y' || answer == 'yes'
      puts "\nOperation cancelled."
      exit 0
    end

    # Remove layout directive from controller
    show_message("Updating Home controller...")
    remove_layout_directive(layout_name_normalized)
    success_message("Home controller updated")

    # Delete layout file
    show_message("Deleting layout file...")
    FileUtils.rm_f(layout_file)
    success_message("Layout file deleted")

    puts "\n #{colorize('Layout successfully deleted!', :green)}"
  end

  def add_pin
    # Check if current directory is a Rails project
    is_rails_project?

    show_title("Adding Importmap Pin: #{@pin_name}")

    # Check bin/importmap file existence
    unless File.exist?('bin/importmap')
      error_message("bin/importmap not found! This project may not be using importmap.")
    end

    # Run bin/importmap pin command
    show_message("Adding pin...")
    output = `bin/importmap pin #{@pin_name} 2>&1`
    
    # Check for errors in output
    if output.include?("Couldn't find") || output.include?("error") || output.include?("Error")
      puts "" # New line
      error_message("Failed to add pin! Package not found: #{@pin_name}")
    end
    
    success_message("Pin added")

    puts "\n #{colorize('Pin successfully added!', :green)}"
    puts " #{colorize('Don\'t forget to import it in your project!', :green)}"
    puts "Package: #{colorize(@pin_name, :blue)}"
  end

  def remove_pin
    # Check if current directory is a Rails project
    is_rails_project?

    show_title("Removing Importmap Pin: #{@pin_name}")

    # Check bin/importmap file existence
    unless File.exist?('bin/importmap')
      error_message("bin/importmap not found! This project may not be using importmap.")
    end

    # Check usage in JavaScript and HTML files
    show_message("Checking usage...")
    used_files = check_pin_usage(@pin_name)
    success_message("Check completed")

    if used_files.any?
      puts "\n"
      puts colorize("WARNING: This package is being used in the following files:", :yellow, bold: true)
      used_files.each do |file|
        puts "  - #{file}"
      end
      puts "\n"
      print colorize("Do you still want to delete it? (y/n): ", :yellow)
      answer = STDIN.gets.chomp.downcase
      unless answer == 'y' || answer == 'yes'
        puts "\nOperation cancelled."
        exit 0
      end
    end

    # Check pin existence
    show_message("Checking pin...")
    importmap_file = 'config/importmap.rb'
    unless File.exist?(importmap_file)
      error_message("config/importmap.rb not found!")
    end
    
    importmap_content = File.read(importmap_file)
    unless importmap_content.match?(/pin\s+["']#{Regexp.escape(@pin_name)}["']/)
      puts "" # New line
      error_message("Pin not found! '#{@pin_name}' is not defined in importmap.")
    end
    success_message("Pin found")

    # Run bin/importmap unpin command
    show_message("Removing pin...")
    output = `bin/importmap unpin #{@pin_name} 2>&1`
    success_message("Pin removed")

    puts "\n #{colorize('Pin successfully removed!', :green)}"
  end

  # Helper methods
  def is_rails_project?
    unless File.exist?('config/routes.rb') && File.exist?('Gemfile')
      error_message("This directory is not a Rails project! Please run inside a Rails project.")
    end
  end

  def run_server
    is_rails_project?

    unless File.exist?('bin/dev')
      error_message("bin/dev file not found! This project may not have been created with Rails 7+.")
    end

    puts "\n#{colorize('Starting Rails server...', :green, bold: true)}"
    puts "#{colorize('Use Ctrl+C to stop', :yellow)}\n\n"
    
    exec('bin/dev')
  end

  def build_static_site
    is_rails_project?
    show_title("Building Static Files")

    # Server check
    show_message("Checking server...")  
    server = check_server
    unless server[:running]
      error_message("Rails server is not running! Start it first with 'rails-frontend run'.")
    end
    success_message("Server is running")
     
    # Mirror with wget
    wget_mirror(server[:port])

    # Prepare build folder
    show_message("Preparing build folder...")  
    configure_build
    success_message("Build folder prepared")
    
    # Move files
    show_message("Organizing files...")
    move_asset_files
    success_message("Files organized")
    
    # Path corrections
    show_message("Fixing paths...")
    fix_html_paths(server[:port])
    fix_css_paths
    success_message("Path fixes completed")
    
    # Cleanup
    show_message("Removing unnecessary components...")
    clean_html_files
    success_message("Unnecessary components removed")
    
    puts "\n#{colorize('✓ Static site successfully built!', :green)}"
    puts "Folder: #{colorize('build/', :blue)}"
    puts "\nTo test:"
    puts "  cd build && python3 -m http.server or npx http-server"
  end

  # Build helper methods
  def check_server
    pid_file = 'tmp/pids/server.pid'
    return { running: false, port: nil } unless File.exist?(pid_file)

    pid = File.read(pid_file).strip.to_i

    begin
      # Find port number
      cmd = `ps -p #{pid} -o args=`.strip
      port = cmd[/tcp:\/\/[^:]+:(\d+)/, 1]

      { running: true, port: port.to_i }
    rescue Errno::ESRCH, Errno::EPERM
      # Process not found or no access
      { running: false, port: nil }
    end
  end

  def wget_mirror(port)
    # Delete previous build folder
    FileUtils.rm_rf('build')

    # Run wget silently
    system("wget --mirror --convert-links --adjust-extension --page-requisites --no-parent --directory-prefix=build http://localhost:#{port}/ > /dev/null 2>&1")
    
    # Move localhost:3000 folder into build/
    if Dir.exist?("build/localhost:#{port}")
      Dir.glob("build/localhost:#{port}/*").each do |file|
        FileUtils.mv(file, 'build/')
      end
      FileUtils.rm_rf("build/localhost:#{port}")
    end
  end

  def configure_build
    ['img', 'js', 'css', 'fonts'].each do |dir|
      FileUtils.mkdir_p("build/assets/#{dir}")
    end
  end

  def move_asset_files
    extensions = [ "{jpg,jpeg,png,gif,svg,webp,ico}", "js", "css", "{woff,woff2,ttf,eot,otf}" ]
    folders = [ "img", "js", "css", "fonts" ]

    extensions.zip(folders).each do |extension, folder|
      Dir.glob("build/**/*.#{extension}").each do |file|
        basename = File.basename(file)
        dest = "build/assets/#{folder}/#{basename}"

        # Move if file exists and destination doesn't
        if File.exist?(file) && !File.exist?(dest)
          FileUtils.mv(file, dest)
        end
      end
    end

    # If controllers folder exists, move contents and delete
    if Dir.exist?("build/assets/controllers")
      Dir.glob("build/assets/controllers/*").each do |file|
        FileUtils.mv(file, 'build/assets/js/')
      end
      FileUtils.rm_rf("build/assets/controllers")
    end

    # Delete turbo files (commented out for now as it may be needed for stimulus)
    # Dir.glob('**/*turbo.min*').each do |file|
    #   FileUtils.rm_rf(file)
    # end
  end

  def fix_html_paths(port)
    Dir.glob('build/**/*.html').each do |file|
      content = File.read(file)
      
      # 1. Add "js/" after "assets/" for lines containing "assets/" and ending with .js
      # Example: assets/application-bfcdf840.js -> assets/js/application-bfcdf840.js
      content.gsub!(/assets\/([^\/\s"']+\.js)/, 'assets/js/\1')
      
      # 2. Add "js/" after "assets/controllers/" for lines containing "assets/controllers/" and ending with .js
      # Example: assets/controllers/index-ee64e1f1.js -> assets/js/index-ee64e1f1.js
      content.gsub!(/assets\/controllers\/([^\/\s"']+\.js)/, 'assets/js/\1')
      
      # 3. Add "css/" after "assets/" for lines containing "assets/" and ending with .css
      # Example: assets/application-72587725.css -> assets/css/application-72587725.css
      content.gsub!(/assets\/([^\/\s"']+\.css)/, 'assets/css/\1')

      # 4. Add "img/" after "assets/" for lines containing "assets/" and ending with image extensions
      # Example: assets/app-image-72587725.jpg -> assets/img/app-image-72587725.jpg
      content.gsub!(/assets\/([^\/\s"']+\.(jpg|jpeg|png|gif|svg|webp))/, 'assets/img/\1')
      content.gsub!(/http:\/\/localhost:#{port}\/([^\/\s"']+\.(jpg|jpeg|png|gif|svg|webp))/, 'assets/img/\1')
      
      File.write(file, content)
    end
  end

  def fix_css_paths
    Dir.glob('build/assets/css/**/*.css').each do |file|
      content = File.read(file)
      
      # Font paths - use absolute path
      # Example: url("LavishlyYours-Regular-c6da7860.ttf") -> url("/assets/fonts/LavishlyYours-Regular-c6da7860.ttf")
      content.gsub!(/url\(["']?([^\/]["'()]*\.(woff2?|ttf|eot|otf))["']?\)/, 'url("/assets/fonts/\1")')
      
      # Image paths - use absolute path
      # Example: url("A-13904566-1761601378-8017-2b819c09.jpg") -> url("/assets/img/A-13904566-1761601378-8017-2b819c09.jpg")
      content.gsub!(/url\(["']?([^\/]["'()]*\.(jpg|jpeg|png|gif|svg|webp))["']?\)/, 'url("/assets/img/\1")')
      
      File.write(file, content)
    end
  end

  def clean_html_files
    Dir.glob('build/**/*.html').each do |file|
      content = File.read(file)
      
      # index.html links
      content.gsub!(/href="[^"]*\/index\.html"/, 'href="/"')
      content.gsub!(/href="index\.html"/, 'href="/"')
      
      # Remove Turbo (commented out for now as it may be needed for stimulus)
      # content.gsub!(/^.*turbo\.min.*$\n?/, '')
      
      # Remove CSRF
      content.gsub!(/<meta name="csrf-param"[^>]*>/, '')
      content.gsub!(/<meta name="csrf-token"[^>]*>/, '')
      
      File.write(file, content)
    end
  end

  # Helper methods
  def add_home_controller_action(page_name)
    controller_path = 'app/controllers/home_controller.rb'
    return unless File.exist?(controller_path)

    # Add small delay (for consecutive operations) 
    sleep(0.1)

    controller_content = File.read(controller_path)
    
    # Don't add if action already exists - check with word boundary
    # "def products" and "def product" should be detected separately
    return if controller_content.match?(/^\s*def\s+#{Regexp.escape(page_name)}\s*$/)

    # Find class definition and add before last end
    lines = controller_content.split("\n")
    
    # Find index of last end line
    last_end_index = lines.rindex { |line| line.strip == 'end' }
    
    if last_end_index
      # Add new action before last end
      new_action_lines = [
        "  def #{page_name}",
        "  end",
        ""
      ]
      
      lines.insert(last_end_index, *new_action_lines)
      controller_content = lines.join("\n")
      File.write(controller_path, controller_content)
    end
  end

  def remove_home_controller_action(page_name)
    controller_path = 'app/controllers/home_controller.rb'
    return unless File.exist?(controller_path)

    controller_content = File.read(controller_path)
    
    # Remove action
    # Find block starting with "  def page_name" and ending with "  end"
    controller_content.gsub!(/^\s*def #{Regexp.escape(page_name)}\s*$.*?^\s*end\s*$/m, '')
    
    # Clean excessive blank lines (reduce to 2 if more than 3 consecutive blank lines)
    controller_content.gsub!(/\n{3,}/, "\n\n")

    File.write(controller_path, controller_content)
  end

  def clean_unnecessary_files
    # Delete files and folders unnecessary for frontend
    unnecessary_files = [
      '.github',
      'app/models',
      'app/javascript/controllers/hello_controller.js',
      'config/environments/production.rb',
      'config/environments/test.rb',
      'lib',
      'public',
      'script'
    ]

    unnecessary_files.each do |file|
      # Don't error if non-existent folder deletion
      FileUtils.rm_rf(file) if File.exist?(file) || Dir.exist?(file)
    end
  end

  def normalize_name(name)
    # Convert Turkish characters and lowercase
    tr_map = {
      'ç' => 'c', 'Ç' => 'c',
      'ğ' => 'g', 'Ğ' => 'g',
      'ı' => 'i', 'İ' => 'i',
      'ö' => 'o', 'Ö' => 'o',
      'ş' => 's', 'Ş' => 's',
      'ü' => 'u', 'Ü' => 'u'
    }
    
    normalized = name.downcase
    tr_map.each { |tr, en| normalized.gsub!(tr, en) }
    normalized.gsub(/[^a-z0-9_]/, '_')
  end

  def get_application_name
    # Read application name from config/application.rb file
    app_config_path = 'config/application.rb'
    if File.exist?(app_config_path)
      content = File.read(app_config_path)
      # Search for "module ApplicationName" pattern
      match = content.match(/module\s+([A-Z][a-zA-Z0-9_]*)/)
      if match
        # Convert CamelCase to title (e.g. MyApp -> My App)
        return match[1].gsub(/([A-Z]+)([A-Z][a-z])/, '\1 \2')
                      .gsub(/([a-z\d])([A-Z])/, '\1 \2')
      end
    end
    
    # Fallback: Use current directory name
    File.basename(Dir.pwd).split('_').map(&:capitalize).join(' ')
  end

  def create_home_controller
    controller_content = <<~RUBY
      class HomeController < ApplicationController
        def index
        end
      end
    RUBY

    FileUtils.mkdir_p('app/controllers')
    File.write('app/controllers/home_controller.rb', controller_content)

    # Create view folder and file
    FileUtils.mkdir_p('app/views/home')
    view_content = <<~HTML
      <div>
        <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
          <div class="container mx-auto px-4 py-16">
            <div class="text-center">
              <h1 class="text-5xl font-bold text-gray-900 mb-4">
                Welcome! 👋
              </h1>
              <p class="text-xl text-gray-600 mb-8">
                Created with Rails Frontend CLI
              </p>
              <div class="inline-block bg-white rounded-lg shadow-lg p-8">
                <p class="text-gray-700 mb-4">
                  Your project has been successfully created and is ready to use!
                </p>
                <p class="text-sm text-gray-500">
                  You can start developing with Tailwind CSS and Stimulus.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    HTML

    File.write('app/views/home/index.html.erb', view_content)
  end

  def create_shared_components
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
        <%= link_to "Home", root_path, class: "text-gray-700 hover:text-indigo-600 transition" %>
        <!-- Other menu items will be added here -->
      </nav>
    HTML
    File.write('app/views/shared/_navbar.html.erb', navbar_content)

    # Footer - Simple and full width
    footer_content = <<~HTML
      <footer class="bg-gray-800 text-white py-6 text-center">
        <p class="text-gray-400">
          © <%= Time.current.year %> All rights reserved.
        </p>
      </footer>
    HTML
    File.write('app/views/shared/_footer.html.erb', footer_content)
  end

  def create_css_files
    FileUtils.mkdir_p('app/assets/stylesheets')

    # Home CSS
    home_css = <<~CSS
      /* Home page custom styles */
      .home-container {
        /* Custom styles for home page can be added here */
      }
    CSS
    File.write('app/assets/stylesheets/home.css', home_css)

    # Header CSS
    header_css = <<~CSS
      /* Header custom styles */
      header {
        /* Custom styles for header can be added here */
      }
    CSS
    File.write('app/assets/stylesheets/header.css', header_css)

    # Navbar CSS
    navbar_css = <<~CSS
      /* Navbar custom styles */
      nav {
        /* Custom styles for navbar can be added here */
      }
    CSS
    File.write('app/assets/stylesheets/navbar.css', navbar_css)

    # Footer CSS
    footer_css = <<~CSS
      /* Footer custom styles */
      footer {
        /* Custom styles for footer can be added here */
      }
    CSS
    File.write('app/assets/stylesheets/footer.css', footer_css)
  end

  def create_stimulus_controller(page_name)
    FileUtils.mkdir_p('app/javascript/controllers')

    controller_content = <<~JS
      import { Controller } from "@hotwired/stimulus"

      // Stimulus controller for #{page_name.capitalize} page
      export default class extends Controller {
        connect() {
          console.log("#{page_name.capitalize} controller connected")
        }

        disconnect() {
          console.log("#{page_name.capitalize} controller disconnected")
        }

        // Custom methods can be added here
      }
    JS

    File.write("app/javascript/controllers/#{page_name}_controller.js", controller_content)
  end

  def create_asset_folders
    # Images folder
    FileUtils.mkdir_p('app/assets/images')
    File.write('app/assets/images/.keep', '')

    # Fonts folder
    FileUtils.mkdir_p('app/assets/fonts')
    File.write('app/assets/fonts/.keep', '')
  end

  def update_layout
    layout_path = 'app/views/layouts/application.html.erb'
    return unless File.exist?(layout_path)

    layout_content = File.read(layout_path)

    # Add UTF-8 charset meta tag (if not present)
    if !layout_content.match?(/<meta\s+charset\s*=\s*["']utf-8["']/i)
      layout_content.gsub!(/<\/title>/) do
        <<~HTML.chomp
          </title>
              <meta charset="utf-8">
        HTML
      end
    end

    # First clean existing main tags
    layout_content.gsub!(/<main[^>]*>/, '')
    layout_content.gsub!(/<\/main>/, '')

    # Add shared components inside body
    if layout_content.include?('<body>')
      new_layout = layout_content.gsub(/<body>/) do
        <<~HTML.chomp
          <body>
            <%= render 'shared/header' %>
            <main class="min-h-screen">
        HTML
      end

      # Add footer after yield
      new_layout = new_layout.gsub(/\s*<%= yield %>/) do
        <<~HTML.chomp
          <%= yield %>
            </main>
            <%= render 'shared/footer' %>
        HTML
      end

      File.write(layout_path, new_layout)
    end
  end

  def update_routes(page_name, action, root: false)
    routes_path = 'config/routes.rb'
    routes_content = File.read(routes_path)

    if root
      # Add root route
      new_route = "  root \"home##{action}\"\n"
      
      # Replace if existing root route exists, otherwise add
      if routes_content.match?(/^\s*root/)
        routes_content.gsub!(/^\s*root.*$/, new_route.strip)
      else
        routes_content.gsub!(/Rails\.application\.routes\.draw do\n/) do |match|
          "#{match}#{new_route}"
        end
      end
    else
      # Add normal route (use home controller)
      new_route = "  get \"/#{page_name}\", to: \"home##{action}\"\n"
      
      # Don't add if route already exists
      unless routes_content.include?(new_route.strip)
        routes_content.gsub!(/Rails\.application\.routes\.draw do\n/) do |match|
          "#{match}#{new_route}"
        end
      end
    end

    File.write(routes_path, routes_content)
  end

  def remove_route(page_name)
    routes_path = 'config/routes.rb'
    routes_content = File.read(routes_path)

    # Remove route line
    routes_content.gsub!(/^\s*get\s+['"]\/#{page_name}['"].*\n/, '')

    File.write(routes_path, routes_content)
  end

  def create_controller(page_name)
    controller_content = <<~RUBY
      class #{page_name.capitalize}Controller < ApplicationController
        def index
        end
      end
    RUBY

    File.write("app/controllers/#{page_name}_controller.rb", controller_content)
  end

  def create_view(page_name)
    # Create view in Home folder
    FileUtils.mkdir_p("app/views/home")

    view_content = <<~HTML
      <div>
        <div class="container mx-auto px-4 py-16">
          <h1 class="text-4xl font-bold text-gray-900 mb-4">
            #{page_name.capitalize}
          </h1>
          <p class="text-gray-600">
            #{page_name.capitalize} page content will go here.
          </p>
        </div>
      </div>
    HTML

    File.write("app/views/home/#{page_name}.html.erb", view_content)
  end

  def create_css(page_name)
    css_content = <<~CSS
      /* #{page_name.capitalize} page custom styles */
      .#{page_name}-container {
        /* Custom styles for #{page_name} page can be added here */
      }
    CSS

    File.write("app/assets/stylesheets/#{page_name}.css", css_content)
  end

  def update_procfile
    procfile_path = 'Procfile.dev'
    
    procfile_content = <<~PROCFILE
      web: bin/rails server -b 0.0.0.0
      css: bin/rails tailwindcss:watch
    PROCFILE
    
    File.write(procfile_path, procfile_content)
  end

  def list_home_views
    views = []
    if Dir.exist?('app/views/home')
      Dir.glob('app/views/home/*.html.erb').each do |file|
        basename = File.basename(file, '.html.erb')
        # Exclude index
        views << basename unless basename == 'index'
      end
    end
    views.sort
  end

  def create_layout_file(layout_name)
    FileUtils.mkdir_p('app/views/layouts')
    
    layout_content = <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <title><%= content_for(:title) || "#{layout_name.capitalize}" %></title>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width,initial-scale=1">
          <meta name="apple-mobile-web-app-capable" content="yes">
          <meta name="application-name" content="#{get_application_name}">
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

    File.write("app/views/layouts/#{layout_name}.html.erb", layout_content)
  end

  def add_layout_directive(layout_name, view_name)
    controller_file = 'app/controllers/home_controller.rb'
    unless File.exist?(controller_file)
      error_message("Home controller not found: #{controller_file}")
    end

    controller_content = File.read(controller_file)
    
    # Check if layout directive already exists
    if controller_content.match?(/layout\s+["']#{layout_name}["']/)
      puts "\n#{colorize("WARNING: This layout directive already exists!", :yellow)}"
      return
    end

    # Add layout directive after class definition
    layout_line = "  layout \"#{layout_name}\", only: :#{view_name}\n"
    
    if controller_content.match?(/class\s+HomeController\s*<\s*ApplicationController\s*\n/)
      controller_content.sub!(/class\s+HomeController\s*<\s*ApplicationController\s*\n/) do |match|
        "#{match}#{layout_line}\n"
      end
    else
      error_message("HomeController class definition not found!")
    end

    File.write(controller_file, controller_content)
  end

  def remove_layout_directive(layout_name)
    controller_file = 'app/controllers/home_controller.rb'
    unless File.exist?(controller_file)
      error_message("Home controller not found: #{controller_file}")
    end

    controller_content = File.read(controller_file)
    
    # Find and remove layout directive
    controller_content.gsub!(/^\s*layout\s+["']#{layout_name}["'].*\n/, '')
    
    File.write(controller_file, controller_content)
  end

  def find_existing_layout_for_view(view_name)
    controller_file = 'app/controllers/home_controller.rb'
    return nil unless File.exist?(controller_file)

    controller_content = File.read(controller_file)
    
    # Search for layout "layout_name", only: :view_name pattern
    match = controller_content.match(/layout\s+["']([^"']+)["'].*only:\s*:#{view_name}\b/)
    match ? match[1] : nil
  end

  def check_pin_usage(pin_name)
    used_files = []
    
    # Search in JavaScript files
    if Dir.exist?('app/javascript')
      Dir.glob('app/javascript/**/*.js').each do |file|
        content = File.read(file)
        # Check for exact match with import or from
        # Example: from "alpinejs" or import "chart.js" or import Alpine from "alpinejs"
        if content.match?(/from\s+["']#{Regexp.escape(pin_name)}["']/) || 
           content.match?(/import\s+["']#{Regexp.escape(pin_name)}["']/) ||
           content.match?(/import\s+.+\s+from\s+["']#{Regexp.escape(pin_name)}["']/)
          used_files << file
        end
      end
    end
    
    # Search in HTML/ERB files
    if Dir.exist?('app/views')
      Dir.glob('app/views/**/*.html.erb').each do |file|
        content = File.read(file)
        # Check for exact match inside script tag or importmap
        # Looking for exact match in quotes
        if content.match?(/["']#{Regexp.escape(pin_name)}["']/)
          used_files << file
        end
      end
    end
    
    used_files.uniq
  end

  # Message methods
  def show_title(message)
    puts colorize(message, :blue, bold: true)
  end

  def show_message(message)
    # Just show message, no numbering
    print "  #{message} "
  end

  def success_message(message)
    puts colorize('OK', :green)
  end

  def error_message(message)
    puts "\n#{colorize('ERROR:', :red)} #{message}\n"
    exit 1
  end

  def completion_message
    puts colorize("Project successfully created!", :green, bold: true)
    puts "\n#{colorize('Next steps:', :blue)}"
    puts "  1. cd #{@project_name}"
    puts "  2. rails-frontend run"
    puts "  3. Open http://localhost:3000 in your browser"
    puts "\n#{colorize('For help:', :blue)}"
    puts "  rails-frontend --help"
    puts ""
  end

  def show_help
    show_title("Rails Frontend CLI v#{VERSION}")
    
    puts colorize("Rails project management tool for frontend developers", :blue)
    puts ""
    puts colorize("USAGE:", :yellow, bold: true)
    puts "  rails-frontend COMMAND [PARAMETERS]"
    puts ""
    
    puts colorize("COMMANDS:", :yellow, bold: true)
    puts <<~COMMANDS
      Project Management:
        new, n PROJECT_NAME [--clean]  Create new Rails frontend project
        build, b                       Build static site
        run, r                         Start server (bin/dev)
        
      Page Management:
        add-page, ap PAGE_NAME         Add new page (view + CSS + route)
        remove-page, rp PAGE_NAME      Remove page
        
      Stimulus Controller:
        add-stimulus, as CONTROLLER    Add Stimulus controller
        remove-stimulus, rs CONTROLLER Remove Stimulus controller (checks usage)
        
      Layout Management:
        add-layout, al LAYOUT_NAME     Add layout (with view matching)
        remove-layout, rl LAYOUT_NAME  Remove layout
        
      JavaScript Libraries:
        add-pin, pin PACKAGE_NAME      Add external JavaScript library
        remove-pin, unpin PACKAGE_NAME Remove external JavaScript library (checks usage)
        
      Info:
        version, -v, --version         Show version info
        help, -h, --help               Show this help message
    COMMANDS
    
    puts colorize("OPTIONS:", :yellow, bold: true)
    puts "  --clean                     Clean unnecessary files for frontend"
    puts "                              (tests, mailers, jobs, channels, models etc.)"
    puts ""
    
    puts colorize("EXAMPLES:", :yellow, bold: true)
    puts <<~EXAMPLES
      Create new project:
        rails-frontend new blog --clean
        
      Add page:
        rails-frontend add-page about
        
      Add layout:
        rails-frontend add-layout contact
        
      Add JavaScript library:
        rails-frontend add-pin sweetalert2
        
      Add Stimulus controller:
        rails-frontend add-stimulus dropdown
        
      Start server:
        rails-frontend run
    EXAMPLES
    
    puts colorize("MORE INFO:", :blue)
    puts "  Detailed user manual: USER_MANUAL.md"
    puts "  GitHub: https://github.com/ozbilgic/rails-frontend-cli"
    puts ""
  end

  def colorize(text, color, bold: false)
    colors = {
      red: 31,
      green: 32,
      yellow: 33,
      blue: 34,
      magenta: 35,
      cyan: 36
    }

    color_code = colors[color] || 37
    bold_code = bold ? '1;' : ''
    
    "\e[#{bold_code}#{color_code}m#{text}\e[0m"
  end
end

# When run as a script
if __FILE__ == $0
  cli = RailsFrontendCLI.new
  cli.run(ARGV)
end
