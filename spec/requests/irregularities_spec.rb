require 'rails_helper'

RSpec.describe "Irregularities", type: :request do
  describe "GET /irregularities" do
    it "works! (now write some real specs)" do
      get irregularities_path
      expect(response).to have_http_status(200)
    end
  end
end
