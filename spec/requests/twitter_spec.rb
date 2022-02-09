# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Twitters', type: :request do
  describe 'POST /send_weather' do
    it 'returns http success', :vcr do
      post '/twitter/send_weather', params: { lat: '-10.2450998', lon: '-48.3513141' }
      expect(response).to have_http_status(:success)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['message']).to eq('Tweet was successfully sent!')
    end

    it 'returns http 400', :vcr do
      post '/twitter/send_weather', params: {}
      expect(response).to have_http_status(400)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['message']).to eq('Missing parameters :lat or :lon')
    end
  end
end
