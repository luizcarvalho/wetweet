# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenWeatherMapService do
  subject { OpenWeatherMapService.new }
  let(:coordinates) { { lat: '-23.561355', lon: '-46.6578882' } }

  describe '.build_client' do
    it { expect(subject.client).to be_a(OpenWeatherMap::ApiClient) }
  end

  describe '.build_tweet' do
    it 'return tweet  text', :vcr do
      tweet = subject.build_tweet(coordinates)

      expect(tweet).to be_a(String)
    end
    context 'when bad variables'
    it 'return tweet  as a Hash', :vcr do
      tweet = subject.build_tweet({})

      expect(tweet).to be_a(Hash)
      expect(tweet[:code]).to eq(400)
      expect(tweet.keys).to include(:message)
    end
  end

  describe '.current_weather', :vcr do
    it 'return weather' do
      weather = subject.current_weather(coordinates)

      expect(weather).to be_a(OpenWeatherMap::Weather)
    end

    context 'when missing coordinates', :vcr do
      it 'return  error hash' do
        expect { subject.current_weather(nil) }.to raise_error(StandardError)
      end
    end
  end

  describe '.forecast_next_days', :vcr do
    it 'return forecast' do
      forecast = subject.forecast_next_days(coordinates)

      expect(forecast).to be_a(OpenWeatherMap::Forecast)
    end
  end

  describe '.temperature_avarage', :vcr do
    it 'return days with temperature avarage' do
      weathers = [
        OpenWeatherMap::Weather.new(dt_txt: '2010-09-01', main: { temp: 10 }),
        OpenWeatherMap::Weather.new(dt_txt: '2010-09-01', main: { temp: 20 }),
        OpenWeatherMap::Weather.new(dt_txt: '2010-09-01', main: { temp: 30 }),
        OpenWeatherMap::Weather.new(dt_txt: '2010-09-02', main: { temp: 15 }),
        OpenWeatherMap::Weather.new(dt_txt: '2010-09-02', main: { temp: 10 }),
        OpenWeatherMap::Weather.new(dt_txt: '2010-09-02', main: { temp: 5 })
      ]

      temp_avarage_by_day = subject.temperature_average(weathers)

      expect(temp_avarage_by_day).to eq({ '01/09' => 20, '02/09' => 10 })
    end
  end
end
