require 'rails_helper'

RSpec.describe "Discoveries", type: :request do

  describe "GET /new" do
    before do
      @base_title = "TOEICer Hiroba"
    end

    it "returns http success" do
      get "/discoveries/new"
      expect(response).to have_http_status(:success)
      assert_select "title", "Create | #{@base_title}"
    end
  end

end
