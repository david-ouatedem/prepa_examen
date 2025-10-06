require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module PrepaExamen
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])

    config.i18n.default_locale = :fr
    config.i18n.available_locales = [:en, :fr]

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
