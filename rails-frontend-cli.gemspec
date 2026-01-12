# frozen_string_literal: true

require_relative "lib/rails_frontend_cli/version"

Gem::Specification.new do |spec|
  spec.name = "rails-frontend-cli"
  spec.version = RailsFrontendCLI::VERSION
  spec.authors = ["Levent Özbilgiç"]
  spec.email = ["ozbilgiclevent@gmail.com"]

  spec.summary = "CLI tool for frontend development with Rails"
  spec.description = "Rails Frontend CLI is a command-line tool that enables fast and easy development of 
                      Rails projects for frontend developers and frontend coding with Rails enjoyable, 
                      even without prior knowledge of Ruby or Rails. I've created a free course on this 
                      topic. You can find the course on the GitHub homepage for this CLI."
  spec.homepage = "https://github.com/ozbilgic/rails-frontend-cli"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ozbilgic/rails-frontend-cli"
  spec.metadata["changelog_uri"] = "https://github.com/ozbilgic/rails-frontend-cli/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob("{lib,exe}/**/*") + %w[README.md LICENSE CHANGELOG.md USER_MANUAL.md]
  spec.bindir = "exe"
  spec.executables = ["rails-frontend"]
  spec.require_paths = ["lib"]

  # Development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
end
