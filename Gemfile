source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.0"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.6"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# SQIDs
gem "sqids"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

#### ========== Frontend ==========
gem "vite_rails", "~> 3.0"
gem "inertia_rails", "~> 3.11"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

#### ========== Authentication ==========
gem "devise", "~> 4.9"
gem "devise_invitable", "~> 2.0.0"
gem "devise-passwordless"
gem "devise-verifiable"

#### ========== Authorization ==========
gem "pundit"

#### ========== Tenant ==========
gem "acts_as_tenant"

### ========== Notification ==========
gem "noticed"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  gem "rubocop-rspec", require: false

  gem "rubocop-rspec_rails", require: false

  gem "ruby-lsp-rspec", require: false

  # Code style checking for factory_bot files (https://github.com/rubocop/rubocop-factory_bot)
  gem "rubocop-factory_bot", require: false

  gem "factory_bot_rails"

  ### ========== Debugging ==========
  gem "prosopite"
  gem "pg_query"
  gem "pry-rails"
  gem "pry-stack_explorer", "~> 0.6.0"

  ### ========== Development ==========
  gem "foreman"
end

group :test do
  gem "rspec-rails", "~> 8.0.2"
  gem "pundit-matchers", "~> 4.0"
  gem "simplecov", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  gem "erb-formatter", require: false

  gem "letter_opener"
end
