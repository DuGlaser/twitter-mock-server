module V1
  class Tweets < Grape::API
    resources :tweets do
      # GET[/:id]
      desc "returns all users"
      params do
        requires :id, type: Integer
      end
      get "/:id" do
        @user = User.find(params[:id])
        @tweets = @user.tweets
      end

      # GET[/:id/feed]
      desc "returns all users"
      params do
        requires :id, type: Integer
      end
      get "/:id/feed" do
        following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
        @tweets = Tweet.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: params[:id])
      end

      # POST[/:id/create]
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

      # DELETE[/:id/delete]
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
