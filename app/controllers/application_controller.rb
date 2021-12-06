class ApplicationController < ActionController::API
    before_action :authorize!

    private

    def current_researcher
        researcher_id = JwtAuthenticationService.decode_token(request)
        @researcher   = Researcher.find_by(id: researcher_id)
    end

    def logged_in?
        !!current_researcher
    end

    def authorize!
        return true if logged_in?

        render json: { message: 'Please log in' }, status: :unauthorized
    end

    def render_jsonapi_internal_server_error(exception)
        puts(exception)
        super(exception)
    end

    rescue_from ActionController::ParameterMissing do
        render json: {}, status: :bad_request
    end
end
  