require 'rails_helper'

RSpec.describe "Authentications", type: :request do

  let(:researcher){
    Researcher.create(
      email: 'researcher@example.com',
      password: 'password',
    )
  }

  describe "POST Authentications#create" do
    it 'create JWT tokens for researcher' do
      auth_params = { authentication: {
        email: researcher.email,
        password: 'password'
      }}
      post '/authentications', params: auth_params.to_json, headers: { "Content-Type": "application/json" }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(201)
    end

    it 'should return errors for invalid auth params' do
      auth_params = { authentication: {
        email: researcher.email,
        password: 'wrong_password'
      }}
      post '/authentications', params: auth_params.to_json, headers: { "Content-Type": "application/json" }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(400)
    end
  end
end
