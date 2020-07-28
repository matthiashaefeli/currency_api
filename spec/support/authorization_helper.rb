module AuthorizationHelper
  def auth_tokens_for_user(user)
    post :login, params: { user: { email: user.email,
                                   password: user.password } }, as: :json
    res = JSON.parse(response.body)
    res['auth_token']
  end
end
