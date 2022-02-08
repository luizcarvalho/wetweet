# frozen_string_literal: true

# Controller to handle Twitters actions
class TwitterController < ApplicationController
  wrap_parameters false

  def send_weather
    twitter_service = TwitterService.new
    twitter_response = twitter_service.send_tweet(twitter_params[:text])

    render json: { message: twitter_response[:message] }, status: twitter_response[:code]
  end

  def twitter_params
    params.permit(:text)
  end
end
