# frozen_string_literal: true

# Override  default confuguration of Gem
OpenWeatherMap.configure do |config|
  config.lang = 'pt_br'
  config.appid = Rails.application.credentials[:open_weather_map][:appid]
end
