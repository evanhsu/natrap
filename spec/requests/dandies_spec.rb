require 'rails_helper'

RSpec.describe "Dandies", type: :request do
  describe "GET /dandies" do
    it "works! (now write some real specs)" do
      get dandies_path
      expect(response).to have_http_status(200)
    end
  end
end
