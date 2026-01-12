# Changelog

## v1.0.5

### Improvements
- **Build Command:**
  - Added wget availability check before running `rails-frontend build` command
  - Clear error message with installation instructions if wget is not installed

---

## v1.0.4

### New Features
- **Static Site Generation:**
  - Added `rails-frontend build` command (short: `b`)
  - Asset organization (img, js, css, fonts folders)
  - Automatic path corrections (HTML and CSS)
  - HTML cleanup (csrf, index.html links)
  - Ready output for static hosting

### Improvements
- Server check (detects server and port before build process)
- Asset folder structure: `build/assets/{img,js,css,fonts}/`
- Path corrections in HTML files:
  - `assets/application.js` → `assets/js/application.js`
  - `assets/controllers/index.js` → `assets/js/index.js`
  - `assets/application.css` → `assets/css/application.css`
- Absolute path usage in CSS files:
  - Font: `url("font.woff2")` → `url("/assets/fonts/font.woff2")`
  - Image: `url("image.jpg")` → `url("/assets/img/image.jpg")`
- CSRF cleanup
- index.html link corrections

### Documentation
- README.md updated
- Static site generation section added to USER_MANUAL.md
- Help message updated
- Command reference tables updated

---

## v1.0.3

### New Features
- **External JavaScript Management:**
  - Added `rails-frontend add-pin PACKAGE_NAME` command (short: `pin`)
  - Added `rails-frontend remove-pin PACKAGE_NAME` command (short: `unpin`)
  - Error check when package not found
  - Usage check before removing pin (in JavaScript and HTML files)
  - Exact match check (partial matches ignored)

### Improvements
- Import check in JavaScript files (`app/javascript/**/*.js`)
- Usage check in HTML files (`app/views/**/*.html.erb`)
- Pin existence check (`config/importmap.rb`)
- Import reminder to user
- Improved error messages

### Documentation
- README.md updated
- External JavaScript management section added to USER_MANUAL.md
- Command reference tables updated
- Rails Frontend Coding training material added

---

## v1.0.2

### New Features
- **Layout Management:**
  - Added `rails-frontend add-layout LAYOUT_NAME` command (short: `al`)
  - Added `rails-frontend remove-layout LAYOUT_NAME` command (short: `rl`)
  - Automatic view matching (if layout name matches view name)
  - Ask user for view selection (if no match)
  - Duplicate layout check for same view
  - Automatic layout directive add/remove to controller

### Improvements
- Layout file creation (`app/views/layouts/`)
- Add `layout "layout_name", only: :view_name` directive to `home_controller.rb`
- Confirmation mechanism before layout removal
- Prevent conflicts with existing layout check

### Documentation
- README.md updated
- Layout management section added to USER_MANUAL.md
- Command reference tables updated

---

## v1.0.1

### New Features
- **Stimulus Controller Management:**
  - Added `rails-frontend add-stimulus CONTROLLER_NAME` command (short: `as`)
  - Added `rails-frontend remove-stimulus CONTROLLER_NAME` command (short: `ds`)
  - Usage check in view files before removing Stimulus controller
  - Warning and confirmation mechanism for used controllers

### Improvements
- Documentation updated (README.md and USER_MANUAL.md)
- Command reference tables updated
- Stimulus controller examples added

---

## v1.0.0 (Initial Release)

### Core Features
- **Project Creation:**
  - `rails-frontend new PROJECT_NAME` command
  - Frontend-focused project creation with `--clean` parameter
  - Automatic Tailwind CSS configuration
  - Shared components (header, navbar, footer)

- **Page Management:**
  - `rails-frontend add-page PAGE_NAME` command
  - `rails-frontend remove-page PAGE_NAME` command
  - Automatic view, CSS and route creation
 
- **Development Tools:**
  - `rails-frontend run` command (start server)
  - Turkish character support (automatic normalize)
  - Asset folders (images, fonts)

- **Cleanup Features (`--clean`):**
  - Skip test files
  - Remove unnecessary Rails features (mailers, jobs, channels, models)

### Documentation
- README.md
- Detailed USER_MANUAL.md

### Technical Details
- Rails 7+ compatibility
- Ruby 3.0+ support
- Tailwind CSS integration
- Stimulus framework support
