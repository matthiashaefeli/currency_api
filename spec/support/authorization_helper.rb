module AuthorizationHelper
  def auth_tokens_for_user(user)
    post :login, params: { user: { email: user.email,
                                   password: user.password } }, as: :json
    res = JSON.parse(response.body)
    res['auth_token']
  end

  def user_and_token
    @controller = UsersController.new
    user = FactoryBot.create(:user)
    token = auth_tokens_for_user(user)
    @controller = CurrenciesController.new
    token
  end
end
