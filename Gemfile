source 'https://rubygems.org'

# Core Stuff
ruby '2.5.5'
gem 'rails', '~> 5.2.5'
gem 'devise'
gem 'devise_invitable'
gem 'puma', '~> 5.5'
gem 'sidekiq'
gem 'figaro'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Font End Stuff
gem "sprockets", ">= 3.7.2" # addresses security vulnerability
gem 'bootstrap', '~> 4.0.0.alpha6'
gem 'tether-rails'
gem 'font-awesome-rails', github: 'bokmann/font-awesome-rails'
gem 'turbolinks', '~> 5'
gem 'jquery-turbolinks'
gem 'jquery_mask_rails', '~> 0.1.0'
gem 'haml-rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 5.0.5'
gem 'jbuilder', '~> 2.5'
gem 'smart_listing', github: 'ColinW520/smart_listing'
gem 'gon'
gem 'local_time'
gem 'wysiwyg-rails'
gem 'unobtrusive_flash', '>=3'
gem 'simple_form'
gem 'momentjs-rails', '>= 2.9.0'
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.42'
gem 'select2-rails'
gem 'meta-tags'
gem 'httparty'
gem 'draper'

# Database Stuff
gem 'pg', '~> 0.18'
gem 'activerecord-session_store'
gem 'friendly_id'
gem 'mimemagic', github: 'mimemagicrb/mimemagic', ref: '01f92d86d15d85cfd0f20dabd025dcbd36a8a60f'
gem "paperclip", "~> 5.2.0" # stores images & files to AWS
gem 'aws-sdk'
gem 'groupdate'
gem 'acts-as-taggable-on'
gem 'phony_rails' # keeps phone numbers consistent.
gem 'ranked-model'
gem 'cocoon'

# Third Party Stuff
gem 'twilio-ruby'
#gem 'instagram',  :git => 'git://github.com/facebookarchive/instagram-ruby-gem.git'
gem 'hashie', '>= 3.5.2'
gem 'stripe'
gem 'mindbody-api', :git => 'git://github.com/wingrunr21/mindbody-api.git'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'html2haml'
  gem 'erb2haml'
  gem 'mailcatcher'
end
