class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create, raise: false
  def create
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id.to_s)
      render json: { message: 'User created successfully', auth_token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private
  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

end