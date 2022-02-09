# frozen_string_literal: true

# Controller to handle Twitters actions
class TwitterController < ApplicationController
  wrap_parameters false

  def send_weather
    open_weather_map_service = OpenWeatherMapService.new
    tweet = open_weather_map_service.build_tweet(twitter_params.to_hash)

    if tweet.is_a?(Hash)
      response = tweet
    else
      twitter_service = TwitterService.new
      response = twitter_service.send_tweet(tweet)
    end

    render json: { message: response[:message] }, status: response[:code]
  end

  private

  def twitter_params
    params.permit(:lat, :lon)
  end
end
