# UsersController
class UsersController < ApplicationController
  before_action :authenticate_request!, except: %i[create login]

  # POST /users/login
  def login
    user = User.find_by(email: user_params[:email].to_s.downcase)

    if user&.authenticate(user_params[:password])
      auth_token = JsonWebToken.encode(user_id: user.id)
      render json: { auth_token: auth_token }, status: :ok
    else
      render json: { error: 'Invalid username/password' }, status: :unauthorized
    end
  end

  # POST /users
  def create
    CurrencyName.create(Connection.list) unless CurrencyName.any?
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user = User.find(params[:id])
    render json: {}, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
