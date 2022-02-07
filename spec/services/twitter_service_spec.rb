# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TwitterService' do
  subject { TwitterService.new }

  describe '#send_tweet' do
    it 'success', :vcr do
      response = subject.send_tweet('Helloo World!')

      expect(response[:code]).to be 200
    end

    it 'return nil if text is nil', :vcr do
      response = subject.send_tweet(nil)

      expect(response[:code]).to eq(400)
    end

    it 'return nil if text is empty', :vcr do
      response = subject.send_tweet('')

      expect(response[:code]).to eq(400)
    end

    it 'Unauthorized', :vcr do
      Rails.application.credentials[:twitter][:consumer_secret] = nil

      response = subject.send_tweet('Teste de autorização')
      expect(response[:code]).to eq(401)
    end

    it 'BadRequest', :vcr do
      Rails.application.credentials[:twitter][:consumer_key] = nil

      response = subject.send_tweet('Teste de autorização')
      expect(response[:code]).to eq(400)
    end

    it 'General error', :vcr do
      $VERBOSE = nil
      Twitter::Error::ERRORS = nil
      $VERBOSE = true

      twitter_service = TwitterService.new

      response = twitter_service.send_tweet('Teste de autorização')
      expect(response[:code]).to eq(500)
    end
  end
end
