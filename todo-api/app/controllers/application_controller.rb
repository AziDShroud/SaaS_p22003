class ApplicationController < ActionController::API
  attr_reader :current_user
  private
  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = JsonWebToken.decode(token) if token

    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
    end
    render json: {errors: 'Unauthorized'}, status: :unauthorized unless @current_user
  end
end
