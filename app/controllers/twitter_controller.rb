# frozen_string_literal: true

# Controller to handle Twitters actions
class TwitterController < ApplicationController
  def send_weather
    twitter_service = TwitterService.new
    twitter_response = twitter_service.send_tweet(params[:text])

    render json: { message: twitter_response[:message] }, status: twitter_response[:code]
  end
end
