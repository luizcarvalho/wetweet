# frozen_string_literal: true

require 'twitter'
require_relative '../../lib/errors'

# Twitter Service is responsible for making requests to Twitter API
class TwitterService
  def initialize
    @client = build_client
  end

  # Send a simple tweet
  #
  # twitter = TwitterService.new
  # twitter.send_tweet('Helloo World =)')
  #
  # @param [String] text Text that will be sent to Twitter
  #
  # @return [Hash<{code: Integer, message: String}>]
  def send_tweet(text)
    raise WeTweet::EmptyTweetError if text.blank?

    @client.update(text)

    { code: 200, message: 'Tweet was successfully sent!' }
  rescue StandardError => e
    handle_errors(e)
  end

  private

  # build a hash with json response informations
  #
  # @param [Exception] error a instace of an exception raised
  #
  # @return [Hash<{code: Integer, message: String}>]
  def handle_errors(error)
    error_status = case error
                   when WeTweet::EmptyTweetError
                     { code: 400, message: 'Tweet text is mandatory' }
                   when Twitter::Error
                     { code: errors_code_for(error.class), message: error.message }
                   else
                     { code: 500, message: 'Internal server error!' }
                   end

    report_error(error)

    error_status
  end

  # Output error message and backtrace information suppressed by exceptions handlers
  # Used to represent a Error tracking for example
  # build a hash with json response informations
  #
  # @param [Exception] error a instace of an exception suppressed
  #
  # @return nil
  def report_error(error)
    Rails.logger.error error.message
    Rails.logger.error error.backtrace.join("\n")
  end

  # build twitter client using credentials information
  #
  # @example credentials format
  #
  # twitter:
  #   consumer_key: xxx
  #   consumer_secret: yyy
  #   access_token: kkk
  #   access_secret: www
  #
  # @return [Twitter::REST::Client]
  def build_client
    twitter_credentials = Rails.application.credentials[:twitter]

    Twitter::REST::Client.new do |config|
      config.consumer_key        = twitter_credentials[:consumer_key]
      config.consumer_secret     = twitter_credentials[:consumer_secret]
      config.access_token        = twitter_credentials[:access_token]
      config.access_token_secret = twitter_credentials[:access_secret]
    end
  end

  # return inverted code-Exception class relation
  #
  # @example Return inverse Hash
  #
  # {
  #   400=>Twitter::Error::BadRequest,
  #   401=>Twitter::Error::Unauthorized,
  #   403=>Twitter::Error::Forbidden,
  #   (...)
  # }
  #
  # @return [Hash<{Exception => Integer}>]
  def errors_code_for(error_class)
    Twitter::Error::ERRORS.invert[error_class]
  end
end
