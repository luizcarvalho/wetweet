# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Twitters', type: :request do
  describe 'GET /send_weather' do
    it 'returns http success', :vcr do
      post '/twitter/send_weather', params: { text: 'Olá mundo' }
      expect(response).to have_http_status(:success)
      parsed_response = JSON.parse(response.body)

      expect(parsed_response['message']).to eq('Tweet was successfully sent!')
    end
  end
end
