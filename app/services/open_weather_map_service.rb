# frozen_string_literal: true

require 'open_weather_map'
require_relative '../../lib/errors'

# Use OpenWeatherMap gem to fetch information about Weather
class OpenWeatherMapService
  attr_accessor :client

  def initialize
    @client = build_client
  end

  # Create text with all information about the weather and forecast to be sent to Twitter
  #
  #    coordinates = {lat: '-10', lon: '-42'}
  #    owm = OpenWeatherMapService.new
  #    owm.build_tweet(coordinates)
  #
  # @param coordinates [Hash]  Text that will be sent to Twitter
  # :lat latitude
  # :lon longitude
  #
  # @return [String]
  def build_tweet(coordinates)
    validate_params(coordinates)

    current_weather = current_weather(coordinates)
    forecast_next_days = forecast_next_days(coordinates)

    temperature_average = temperature_average(forecast_next_days.weathers)
    apply_template(current_weather, temperature_average)
  rescue StandardError => e
    handle_errors(e)
  end

  # Format Weather and Forecast average objects to readable text
  #
  #    current_weather = <OpenWeatherMap::Weather>
  #    temperature_average = { '01/09' => 20, '02/09' => 10 }
  #    apply_template
  #
  # @param [OpenWeatherMap::Weather] current_weather with current weather information
  # @param [Hash] temperature_average  with average of temperature to next days
  #    format: { '01/09' => 20, '02/09' => 10 }
  #
  # @return [String]
  def apply_template(current_weather, temperature_average)
    forecast_text = temperature_average.map { |k, v| "#{v}°C em #{k}" }

    "A temperatura é de #{current_weather.temp}°C e #{current_weather.weather_description} "\
      "em #{current_weather.location_name} em #{Time.now.strftime('%d/%m')}. "\
      "Média para os próximos dias: #{forecast_text.join(', ')}"
  end

  #
  # Return  a current weather object from coordinates
  #
  # @param [Hash] coordinates {lat: , lon:}
  #
  # @return [OpenWeatherMap::Weather]
  #
  def current_weather(coordinates)
    response = @client.call_api('data/weather', query_params: coordinates)

    OpenWeatherMap::Weather.new(response)
  end

  #
  # Return a forecast for next 5 days from coordinates
  #
  # @param [Hash] coordinates {lat: , lon:}
  #
  # @return [OpenWeatherMap::Forecast]
  #
  def forecast_next_days(coordinates)
    response = @client.call_api('data/forecast', query_params: coordinates)

    OpenWeatherMap::Forecast.new(response)
  end

  #
  # Calculate average of forecast by date
  #
  # @param [Array] weathers `[<OpenWeatherMap::Weather>]`
  #
  # @return [Hash] `{ '01/09' => 20, '02/09' => 10 }`
  #
  def temperature_average(weathers)
    calculated_temperatures = {}
    group_temperature_by_day(weathers).each_pair do |date, values|
      calculated_temperatures[date] = (values.sum { |v| v[1] } / values.size).round(2)
    end

    calculated_temperatures
  end

  #
  # Group and format (`day/month`) `Weather` by `date`
  #
  # @param [Array] weathers `[<OpenWeatherMap::Weather>]`
  #
  # @return [Hash] `{'01/09' => [ ['01/09', 20], ['01/09' => 10 ]]}`
  #
  def group_temperature_by_day(weathers)
    array_of_temperature = weathers.map do |weather|
      [weather.date.strftime('%d/%m'), weather.temperature]
    end

    array_of_temperature.group_by { |i| i[0].itself }
  end

  #
  # Identify and parse Json with error code and message or raise exception
  #
  # @param [Exception] error error returned by OpenWeatherMap::ApiClient or re-raise error
  #
  # @return [Hash] `{code: 400, message: 'Error message here'}`
  #
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
  # @example credentials format
  #
  # open_weather_map:
  #   appid: xxx
  #
  # @return [OpenWeatherMap::ApiClient]
  def build_client
    OpenWeatherMap::ApiClient.new
  end
end
