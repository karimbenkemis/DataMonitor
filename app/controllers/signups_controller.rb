class SignupsController < ApplicationController
    include JSONAPI::Deserialization
    skip_before_action :authorize!

    def create
        researcher = Researcher.new(jsonapi_deserialize(params, only: signup_params))
        Rails.logger.info "action: #{request.method}, Insert researcher in DataBase: #{researcher.to_json}"

        if researcher.save
            render json: researcher.slice(signup_params), status: :created
        else
            render json: { errors: researcher.errors.full_messages }, status: :bad_request
        end
    end

    private

    def signup_params
        %i[email password]
    end
end
  