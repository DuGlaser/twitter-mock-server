module V1
  class Tweets < Grape::API
    resources :tweets do
      # GET[/]
      desc "returns all users"
      params do
        requires :id, type: Integer
      end
      get "/:id" do
        @user = User.find(params[:id])
        @tweets = @user.tweets
      end

      desc "create tweet"
      params do
        requires :content, type: String
        requires :id, type: Integer
      end
      post "/:id/create" do
        @user = User.find_by("id": params[:id])
        if @user.authenticated?(cookies[:remember_token])
          @user.tweets.create(content: params[:content])
        else
          error!("permission denied", 401)
        end
      end

      desc "delete tweet"
      params do
        requires :id, type: Integer
      end
      delete "/:id/delete" do
        @tweet = Tweet.find_by("id": params[:id])
        @user = @tweet.user
        if @user.authenticated?(cookies[:remember_token])
          @tweet.delete
        else
          error!("permission denied", 401)
        end
      end
    end
  end
end
