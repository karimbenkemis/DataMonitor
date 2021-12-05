class AuthenticationsController < ApplicationController
    skip_before_action :authorize!

    def create
        researcher = Researcher.find_by(email: authentication_params[:email])

        if researcher && researcher.authenticate(authentication_params[:password])
            token = JwtAuthenticationService.encode_token({ researcher_id: researcher.id })
            render json: {
                researcher_id: researcher.id,
                researcher_email: researcher.email,
                token: token
            }, status: :created
        else
            render json: { error: 'Invalid email or password' }, status: :bad_request
        end
    end

    private

    def authentication_params
        params.require(:authentication).permit(:email, :password)
    end
end
  