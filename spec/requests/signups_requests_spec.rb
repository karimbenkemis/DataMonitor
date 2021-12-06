require 'rails_helper'

RSpec.describe "Signups", type: :request do
  describe "POST /create" do
    fit "returns http success" do
      researcher_data = {
        data: {
          attributes: {
            email: 'researcher@example.com',
            password: 'password'
          }
        }
      }
      expect {
        post '/signup', params: researcher_data.to_json, headers: { "Content-Type": "application/json" }
      }.to change(Researcher, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    fit "returns http error when missing password" do
      researcher_data = {
        data: {
          attributes: {
            email: 'researcher@example.com'
          }
        }
      }
      expect {
        post '/signup', params: researcher_data.to_json, headers: { "Content-Type": "application/json" }
      }.to change(Researcher, :count).by(0)
      expect(response).to have_http_status(:bad_request)
    end

  end
end
