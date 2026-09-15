class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: { id: user.id, email: user.email } }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private
  def user_params
    params.permit(:name, :email, :password)
  end

end