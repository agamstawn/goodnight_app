require 'rails_helper'
require 'benchmark'

RSpec.describe "Api::V1::SleepTimeRecordsController", type: :request do
  let!(:user) { User.create(name: "Test User") }

  before do
    1000.times do |i|
      user.sleep_time_records.create!(sleep_time: Time.now - (i+1).hours, wake_time: Time.now - i.hours)
    end
  end

  describe "GET /api/v1/users/:user_id/sleep_time_records?page_size=1000" do
    it "returns sleep records in descending order and handles high volume" do
      time_taken = Benchmark.realtime do
        get "/api/v1/users/#{user.id}/sleep_time_records?page_size=1000"
      end

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      if json_response.key?("records")
        records = json_response["records"]
        expect(records.size).to eq(20)
        
        first_sleep_time = Time.parse(records.first["sleep_time"])
        last_sleep_time = Time.parse(records.last["sleep_time"])
        expect(first_sleep_time).to be > last_sleep_time
      else
        expect(json_response.size).to eq(1000)
        
        first_sleep_time = Time.parse(json_response.first["sleep_time"])
        last_sleep_time = Time.parse(json_response.last["sleep_time"])
        expect(first_sleep_time).to be > last_sleep_time
      end

      puts "Response time for 1000 records: #{time_taken.round(3)}s"
    end
  end

end
