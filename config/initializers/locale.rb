# in config/initializers/locale.rb

# tell the I18n library where to find your translations
I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]

# set default locale to something other than :en
I18n.default_locale = :en

# list of valid languages
Languages = Rails.root.join('./config/locales').children.map{|f| m = /\/([a-z]{2})\.yml$/.match(f.to_s); m[1] if m }.compact

# regular expression for the valid languages
Languages_regexp = Regexp.new(Languages.join('|'))
