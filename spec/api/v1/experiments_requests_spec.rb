require 'rails_helper'

describe 'API v1', apivore: true, version: :v1 do
  describe '/api/v1/experiments/' do

    let(:user) do
        Researcher.create(
          email: 'researcher@example.com',
          password: 'password'
        )
    end

    describe 'GET' do

      let (:route) { '/api/v1/experiments/' }
      context 'with no JWT' do
          it 'receives 401 response' do
            get "/api/v1/experiments/", headers: {}
            expect(response).to have_http_status(401)
            #expect(subject).to validate(method, route, 401, params.merge('_headers': {}))
          end
      end

      context 'with wrong JWT' do
          it 'receives 401 response' do
            get "/api/v1/experiments/", headers: {'Authorization': "wrong jwt"}
            expect(response).to have_http_status(401)
            #expect(subject).to validate(method, route, 401, params.merge('_headers': { 'Authorization': "wrong jwt" }))
          end
      end

      context 'with the right JWT' do
          it 'receives 200 response' do
            auth_token = authenticate_user(user)

            get "/api/v1/experiments/", headers: {'Authorization': "Bearer #{auth_token}"}
            expect(response).to have_http_status(200)
            #expect(subject).to validate(method, route, 200, params.merge({ 'Authorization': "Bearer #{auth_token}" }))

          end
      end
    end

    describe 'POST' do
      let(:method) { :get }

      let(:params) do
          {
          'data': [1.0, 2.1, 3.3],
          'threshold': 2
          }
      end

      let (:route) { '/api/v1/experiments/' }

      context 'with no JWT' do
          it 'receives 401 response' do
            post "/api/v1/experiments/", headers: {}
            expect(response).to have_http_status(401)
          end
      end

      context 'with wrong JWT' do
          it 'receives 401 response' do
            post "/api/v1/experiments/", headers: {'Authorization' => "wrong jwt"}
            expect(response).to have_http_status(401)
          end
      end

      context 'with the right JWT' do
          context 'with empty data' do
              it 'receives 400 response' do
                  auth_token = authenticate_user(user)
                  post "/api/v1/experiments/", headers: {'Authorization': "Bearer #{auth_token}"}
                  expect(response).to have_http_status(400)
              end
          end

          context 'with data' do
              it 'receives 201 response' do
                auth_token = authenticate_user(user)
                post "/api/v1/experiments/", params: params.to_json, headers: {'Authorization': "Bearer #{auth_token}", 'Content-Type': 'application/json'}
                expect(response).to have_http_status(201)
                json = JSON.parse(response.body)
                expect(json['data']).to eq([1.0, 2.1, 3.3])
                expect(json['threshold']).to eq(2.0)
                expect(json['signal']).to eq([0, 1, 1])
              end
          end
      end
    end
  end
end