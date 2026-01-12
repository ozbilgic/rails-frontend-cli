# Rails Frontend CLI

**English** | [Türkçe](README_tr.md)  

A CLI tool that makes frontend development with Rails incredibly easy, allowing you to enjoy Rails frontend coding without needing to know Ruby or Rails.

## Documentation

For detailed usage guide, see [USER_MANUAL.md](USER_MANUAL.md)

## Rails Frontend Coding Course (Free)

📚 [Course material](https://gamma.app/docs/Frontend-Coding-Training-with-Rails-thatg6lvcpx4g7l) (English) | 📚 [Kurs materyali](https://gamma.app/docs/Rails-ile-Frontend-Kodlama-Egitimi-i6q19pjb2jpw9ny) (Türkçe)

## Features

✅ Compatible with Rails 7+  
✅ Automatic Tailwind CSS configuration  
✅ Stimulus controller support  
✅ Shared components (header, navbar, footer)  
✅ Layout management support  
✅ External JavaScript library management  
✅ Automatic route configuration  
✅ Automatic CSS file imports  
✅ Asset folders (images, fonts)  
✅ Multi-language documentation  

## Quick Start

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
rails-frontend --version
```

### Usage

```bash
# Create new project (clean frontend - recommended)
# Unnecessary files for frontend won't be created
rails-frontend new blog --clean
cd blog
rails-frontend run

# Add pages
rails-frontend add-page about
rails-frontend add-page contact

# Add Stimulus controllers
rails-frontend add-stimulus dropdown
rails-frontend add-stimulus modal

# Remove page
rails-frontend remove-page contact

# Remove Stimulus controller (checks usage)
rails-frontend remove-stimulus dropdown

# Add layout
rails-frontend add-layout contact

# Remove layout
rails-frontend remove-layout contact

# Add external JavaScript library
rails-frontend add-pin alpinejs
rails-frontend add-pin sweetalert2

# Remove external JavaScript library (checks usage)
rails-frontend remove-pin alpinejs
rails-frontend remove-pin sweetalert2
```

**`--clean` Parameter:**
Removes unnecessary Rails features for frontend (tests, mailers, jobs, channels, models, etc.). Recommended for frontend-focused projects.

## Commands

| Command | Short | Description |
|---------|-------|-------------|
| `rails-frontend new PROJECT [--clean]` | `n` | Create new project |
| `rails-frontend add-page PAGE` | `ap` | Add page |
| `rails-frontend remove-page PAGE` | `rp` | Remove page |
| `rails-frontend add-stimulus CONTROLLER` | `as` | Add Stimulus controller |
| `rails-frontend remove-stimulus CONTROLLER` | `rs` | Remove Stimulus controller |
| `rails-frontend add-layout LAYOUT` | `al` | Add layout |
| `rails-frontend remove-layout LAYOUT` | `rl` | Remove layout |
| `rails-frontend add-pin PACKAGE` | `pin` | Add external JavaScript library |
| `rails-frontend remove-pin PACKAGE` | `unpin` | Remove external JavaScript library |
| `rails-frontend run` | `r` | Start server |
| `rails-frontend build` | `b` | Build static site |
| `rails-frontend version` | `-v` | Show version |
| `rails-frontend help` | `-h` | Show help |

**Options:**
- `--clean`: Clean unnecessary files for frontend (recommended)

## Requirements

- Ruby 3.0+
- Rails 7+

## Author

Levent Özbilgiç  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/leventozbilgic/)

## License

MIT
