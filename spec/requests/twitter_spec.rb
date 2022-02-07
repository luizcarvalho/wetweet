# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Twitters', type: :request do
  describe 'GET /send_weather' do
    it 'returns http success', :vcr do
      get '/twitter/send_weather?text=hello'
      expect(response).to have_http_status(:success)
      expect(response.message).to eq('Tweet was successfully sent!')
    end
  end
end
