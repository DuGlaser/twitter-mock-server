module V1
  class Root < Grape::API
    version :v1
    format :json

    helpers do
      def set_cookie(user)
        user.remember
        cookies[:user_id] = { value: user.id, path: "/v1" }
        cookies[:remember_token] = { value: user.remember_token, path: "/v1" }
        @current_user = user
      end

      def current_user
        user_id = cookies[:user_id]
        User.find_by(id: user_id)
      end
    end

    mount V1::Users
    mount V1::Tweets
  end
end
