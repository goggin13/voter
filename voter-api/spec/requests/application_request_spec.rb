require 'rails_helper'

RSpec.describe "Application", type: :request do
  describe "GET /heartbeat" do
    it "returns 200" do
      get "/heartbeat"
      expect(response).to have_http_status(200)
    end
  end
end
