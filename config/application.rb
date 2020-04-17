require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Toeic
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.i18n.default_locale = :ja    # デフォルトのロケールをjaに設定

    config.time_zone = 'Asia/Tokyo'     # タイムゾーンを日本に設定

    # config/localesから複数のファイルを読み込めるようにする
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]

    config.generators do |g|
      g.test_framework :rspec,
        view_specs: false,    # ジェネレータの際にviewファイルなどはPSpecに作られないようにする
        helper_specs: false,
        routing_specs: false
    end
  end
end
