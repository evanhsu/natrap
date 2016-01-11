require 'rails_helper'

RSpec.describe "Requisitions", type: :request do
  describe "GET /requisitions" do
    it "works! (now write some real specs)" do
      get requisitions_path
      expect(response).to have_http_status(200)
    end
  end
end
