# Rails Frontend CLI - User Manual

**English** | [Türkçe](KULLANIM_KILAVUZU.md)

A CLI tool that makes frontend development with Rails incredibly easy, allowing you to enjoy Rails frontend coding without needing to know Ruby or Rails.

## Rails Frontend Coding Course (Free)

📚 [Course material](https://gamma.app/docs/Frontend-Coding-Training-with-Rails-thatg6lvcpx4g7l) (English)

### Installation

```bash
gem install rails-frontend-cli
```

### Uninstallation

```bash
gem uninstall rails-frontend-cli
```

### Test Installation

```bash
# For version information:
rails-frontend --version
```

## Usage

### Creating a New Project

```bash
# Clean frontend project (recommended)
# Unnecessary files for frontend won't be created
rails-frontend new blog --clean
cd blog
rails-frontend run

# Standard project
rails-frontend new blog
cd blog
rails-frontend run
```

Open `http://localhost:3000` in your browser.

### `--clean` Parameter

When a project is created with the `--clean` parameter, unnecessary Rails features for frontend development are removed:

**Skipped Features:**
- Test files (`--skip-test`, `--skip-system-test`)
- Action Mailer (`--skip-action-mailer`)
- Action Mailbox (`--skip-action-mailbox`)
- Action Text (`--skip-action-text`)
- Active Job (`--skip-active-job`)
- Action Cable (`--skip-action-cable`)
- Action Storage (`--skip-active-storage`)
- Active Record (`--skip-active-record`)
- ...

**Deleted Files and Folders:**
- `app/mailers/`
- `app/jobs/`
- `app/models`
- `test/`
- `app/channels/`
- `config/cable.yml`, `config/queue.yml`, `config/recurring.yml`
- `db/queue_schema.rb`, `db/cable_schema.rb`
- `bin/jobs`
- `.kamal`

### Adding a New Page

While inside an existing Rails project:

```bash
rails-frontend add-page PAGE_NAME
```

**Examples:**
```bash
cd blog
rails-frontend add-page about
rails-frontend add-page contact
rails-frontend add-page products
```

Automatically created for each page:
- View (`app/views/home/PAGE_NAME.html.erb`) - in home folder
- CSS file (`app/assets/stylesheets/PAGE_NAME.css`)
- Action added to Home controller
- Route (`/PAGE_NAME` -> `home#PAGE_NAME`)

### Starting the Server

```bash
rails-frontend run
```

This command starts the Rails server by running the `bin/dev` file.

### Building a Static Site

```bash
rails-frontend build
# or short name
rails-frontend b
```

**How it Works:**
1. Checks if Rails server is running
2. Cleans and prepares the `build/` folder if it exists
3. Creates `build/assets/{img,js,css,fonts}` folders
4. Organizes all files (images, js, css, fonts)
5. Fixes paths in HTML and CSS files
6. Cleans HTML files (csrf, index.html links)

**Important:** Rails server must be running before executing this command!

**Example Usage:**
```bash
# Terminal 1 - Start server
rails-frontend run

# Terminal 2 - Create build
rails-frontend build

# Test build folder
cd build && python3 -m http.server or npx http-server
```

**Generated Folder Structure:**
```
build/
├── assets/
│   ├── img/          # All image files
│   ├── js/           # All JavaScript files
│   ├── css/          # All CSS files
│   └── fonts/        # All font files
└── *.html            # HTML pages
```

### Removing a Page

```bash
rails-frontend remove-page PAGE_NAME
```

**Example:**
```bash
rails-frontend remove-page contact
```

**Note:** The home page (home/index) cannot be deleted.

### Adding a Stimulus Controller

```bash
rails-frontend add-stimulus CONTROLLER_NAME
```

**Examples:**
```bash
cd blog
rails-frontend add-stimulus dropdown
rails-frontend add-stimulus modal
rails-frontend add-stimulus tabs
```

This command automatically creates:
- Stimulus controller (`app/javascript/controllers/CONTROLLER_NAME_controller.js`)
- Turkish characters are normalized

### Removing a Stimulus Controller

```bash
rails-frontend remove-stimulus CONTROLLER_NAME
```

**Examples:**
```bash
rails-frontend remove-stimulus dropdown
rails-frontend remove-stimulus modal
```

**Important:** Before deletion, this command:
1. Checks if the controller file exists
2. Checks usage in all HTML files under `app/views`
3. Lists files where the controller is used
4. Asks for user confirmation

**Example Output:**
```
WARNING: This controller is being used in the following files:
  - app/views/home/index.html.erb
  - app/views/home/products.html.erb

Do you still want to delete it? (y/n):
```

### Adding a Layout

```bash
rails-frontend add-layout LAYOUT_NAME
```

**Examples:**
```bash
cd blog
rails-frontend add-layout contact
```

**How it Works:**
1. Searches for a view file matching the layout name
2. If a matching view exists, automatically creates the layout file
3. If no matching view exists, asks the user which view to use
4. Checks for existing layout for the same view
5. Creates layout file (`app/views/layouts/`)
6. Adds layout assignment to `home_controller.rb`

### Removing a Layout

```bash
rails-frontend remove-layout LAYOUT_NAME
```

**Examples:**
```bash
rails-frontend remove-layout contact
```

**Important:** Before deletion, this command:
1. Checks if the layout file exists
2. Asks for user confirmation
3. Removes layout assignment from controller
4. Deletes the layout file

### Adding a JavaScript Library

```bash
rails-frontend add-pin PACKAGE_NAME
```

**Examples:**
```bash
cd blog
rails-frontend add-pin alpinejs
rails-frontend add-pin sweetalert2
rails-frontend add-pin chart.js
```

**How it Works:**
1. Package is found from jspm and added to `config/importmap.rb`
2. If successful, reminds user to import

**Important:** Don't forget to import in your JavaScript file after adding a pin:
```javascript
// app/javascript/application.js
import Swal from "sweetalert2"
```

### Removing a JavaScript Library

```bash
rails-frontend remove-pin PACKAGE_NAME
```

**Examples:**
```bash
rails-frontend remove-pin alpinejs
rails-frontend remove-pin sweetalert2
```

**Important:** Before deletion, this command:
1. Checks usage in JavaScript files (`app/javascript/**/*.js`)
2. Checks usage in HTML files (`app/views/**/*.html.erb`)
3. Checks if pin exists in `config/importmap.rb`
4. Shows warning and asks for confirmation if in use

## Project Structure

Newly created projects have the following structure:

```
project_name/
├── app/
│   ├── controllers/
│   │   └── home_controller.rb  (all actions here)
│   ├── views/
│   │   ├── home/
│   │   │   ├── index.html.erb
│   │   │   ├── about.html.erb
│   │   │   └── contact.html.erb
│   │   ├── shared/
│   │   │   ├── _header.html.erb
│   │   │   ├── _navbar.html.erb
│   │   │   └── _footer.html.erb
│   │   └── layouts/
│   │       └── application.html.erb (updated)
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
    └── routes.rb (root configured)
```

## Using Tailwind CSS

Projects come with Tailwind CSS. You can use Tailwind classes directly:

```html
<div class="container mx-auto px-4 py-8">
  <h1 class="text-4xl font-bold text-blue-600">Title</h1>
  <p class="text-gray-700 mt-4">Content...</p>
</div>
```

### Adding Custom CSS

You can use the automatically generated CSS file for each page:

```css
/* app/assets/stylesheets/about.css */
.about-container {
  background: linear-gradient(to right, #667eea, #764ba2);
}
```

CSS files are automatically imported into the `application.tailwind.css` file.

### Stimulus Features and Usage Example

- **Targets:** Easy access to DOM elements
- **Actions:** Event handling
- **Values:** Data sharing with data attributes

**Example:**
```html
<div data-controller="products" 
     data-products-count-value="0">
  <button data-action="products#increment">+</button>
  <span data-products-target="counter">0</span>
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

## Shared Components

The main layout file automatically includes shared components:
You can customize them as you wish.

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

### Using Links

```erb
<%= link_to "Home", root_path %>
<%= link_to "About", about_path %>
<%= link_to "Contact", contact_path %>
```

## Command Reference

| Command | Short | Description |
|---------|-------|-------------|
| `rails-frontend new PROJECT [--clean]` | `n` | Create new project |
| `rails-frontend build` | `b` | Build static site |
| `rails-frontend add-page PAGE` | `ap` | Add page |
| `rails-frontend remove-page PAGE` | `rp` | Remove page |
| `rails-frontend add-stimulus CONTROLLER` | `as` | Add Stimulus controller |
| `rails-frontend remove-stimulus CONTROLLER` | `rs` | Remove Stimulus controller |
| `rails-frontend add-layout LAYOUT` | `al` | Add layout |
| `rails-frontend remove-layout LAYOUT` | `rl` | Remove layout |
| `rails-frontend add-pin PACKAGE` | `pin` | Add external JavaScript library |
| `rails-frontend remove-pin PACKAGE` | `unpin` | Remove external JavaScript library |
| `rails-frontend run` | `r` | Start server |
| `rails-frontend version` | `-v` | Show version |
| `rails-frontend help` | `-h` | Show help |

## Troubleshooting

### 1. Command not found error

**Problem:** `rails-frontend: command not found`

**Solution:**
```bash
# Make sure you load the gem.
gem list rails-frontend-cli

# If not installed
gem install rails-frontend-cli
```

### 2. Tailwind CSS not working

**Problem:** Tailwind classes not being applied

**Solution:**
```bash
# Recompile Tailwind (while in project folder)
bin/rails tailwindcss:build
```

### 3. Stimulus controller not working

**Problem:** "Controller not found" error in console

**Solution:**
```bash
# Recompile JavaScript (while in project folder)
bin/rails assets:precompile
```

### 4. Turkish character issues

**Problem:** Error when using Turkish characters in page names

**Solution:** Turkish characters are now automatically converted:
- `hakkımızda` → `hakkimizda`
- `ürünler` → `urunler`
- `iletişim` → `iletisim`

## Tips

### Component Library

Create reusable components:

```erb
<!-- app/views/shared/_card.html.erb -->
<div class="bg-white rounded-lg shadow-lg p-6">
  <h3 class="text-xl font-bold mb-2"><%= title %></h3>
  <p class="text-gray-600"><%= content %></p>
</div>
```

Usage:
```erb
<%= render 'shared/card', title: 'Title', content: 'Content' %>
```

## Additional Resources

- **Tailwind CSS:** https://tailwindcss.com/docs
- **Stimulus:** https://stimulus.hotwired.dev/
- **SCSS:** https://sass-lang.com/documentation/syntax/

## Support

If you encounter issues:

1. Run `rails-frontend help` command
2. Check Rails log files: `log/development.log`
3. Check browser console (F12)

## Author

Levent Özbilgiç  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/leventozbilgic/)

## License

MIT

---

**Happy coding! 🚀**
