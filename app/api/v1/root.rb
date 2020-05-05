module V1
  class Root < Grape::API
    version :v1
    format :json

    TOKEN_PREFIX = /^Bearer\s/
    TOKEN_REGEX = /^Bearer\s(.+)/
    helpers do
      def set_cookie(user)
        user.remember
        cookies[:user_id] = user.id
        cookies[:remember_token] = user.remember_token
      end
    end

    mount V1::Users
  end
end
