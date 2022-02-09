# frozen_string_literal: true

require 'open_weather_map'
require_relative '../../lib/errors'

# Use OpenWeatherMap gem to fetch information about Weather
class OpenWeatherMapService
  attr_accessor :client

  def initialize
    @client = build_client
  end

  def build_tweet(coordinates)
    validate_params(coordinates)

    current_weather = current_weather(coordinates)
    forecast_next_days = forecast_next_days(coordinates)

    temperature_average = temperature_average(forecast_next_days.weathers)
    apply_template(current_weather, temperature_average)
  rescue StandardError => e
    handle_errors(e)
  end

  def apply_template(current_weather, temperature_average)
    forecast_text = temperature_average.map { |k, v| "#{v}°C em #{k}" }

    "A temperatura é de #{current_weather.temp}°C e #{current_weather.weather_description} "\
      "em #{current_weather.location_name} em #{Time.now.strftime('%d/%m')}. "\
      "Média para os próximos dias: #{forecast_text.join(', ')}"
  end

  def current_weather(coordinates)
    response = @client.call_api('data/weather', query_params: coordinates)

    OpenWeatherMap::Weather.new(response)
  end

  def forecast_next_days(coordinates)
    response = @client.call_api('data/forecast', query_params: coordinates)

    OpenWeatherMap::Forecast.new(response)
  end

  def temperature_average(weathers)
    calculated_temperatures = {}
    group_temperature_by_day(weathers).each_pair do |date, values|
      calculated_temperatures[date] = (values.sum { |v| v[1] } / values.size).round(2)
    end

    calculated_temperatures
  end

  def group_temperature_by_day(weathers)
    array_of_temperature = weathers.map do |weather|
      [weather.date.strftime('%d/%m'), weather.temperature]
    end

    array_of_temperature.group_by { |i| i[0].itself }
  end

  def handle_errors(error)
    error_message = error.message

    raise error unless error_message =~ /"cod"/

    error_json = JSON.parse(error_message, symbolize_names: true)

    error_json.merge({ code: error_json[:cod] })
  end

  def validate_params(params)
    params = params.transform_keys(&:to_sym)
    valid = params.key?(:lat) && params.key?(:lon) && params[:lat] && params[:lon]

    raise WeTweet::MissingParameterError, '{"cod": 400, "message": "Missing parameters :lat or :lon"}' unless valid
  end

  # build OpenWeatherMap client using credentials information
  #
  # @example
  #
  # credentials using this format
  #
  # open_weather_map:
  #   appid: xxx
  #
  # @return [OpenWeatherMap::ApiClient]
  def build_client
    OpenWeatherMap::ApiClient.new
  end
end
