module V1
  class Users < Grape::API
    resources :users do
      # GET[/]
      desc "returns all users"
      get "/" do
        @users = User.all
        present @users, with: V1::Entities::UserEntity
      end

      # POST[/singup]
      desc "Create an User"
      params do
        requires :name, type: String
        requires :email, type: String
        requires :password, type: String
      end
      post "/signup" do
        @user = User.create(
          declared(params)
        )

        if @user.save
          status 201
          present @user, with: V1::Entities::UserEntity
        else
          @user.errors.full_messages
        end
      end

      # POST[/login]
      desc "login"
      params do
        requires :email, type: String
        requires :password, type: String
      end
      post "/login" do
        @user = User.find_by(email: params[:email])
        if @user.authenticate(params[:password])
          set_cookie(@user)
          present @user, with: V1::Entities::UserEntity
        else
          error!("Unauthorized. Invalid email or password.", 401)
        end
      end

      # GET[/:id]
      desc "returns an User"
      params do
        requires :id, type: Integer
      end
      get "/:id" do
        @user = User.find(params[:id])
        return {
                 id: @user.id,
                 name: @user.name, bio: @user.bio,
                 following: @user.following.count,
                 followed: @user.followers.count,
                 isfollowed: current_user.following?(@user),
               }
      end

      # patch[/:id]
      desc "Delete an User"
      params do
        requires :name, type: String
        requires :bio, type: String
      end
      patch "/:id" do
        @user = User.find_by("id": params[:id])
        if @user.authenticated?(cookies[:remember_token])
          @user.name = params[:name] if params[:name].present?
          @user.bio = params[:bio] if params[:bio].present?
          if (@user.save)
            present @user, with: V1::Entities::UserEntity
          end
        else
          error!("permission denied", 401)
        end
      end

      # DELETE[/:id]
      desc "Delete an User"
      params do
        requires :id, type: Integer
      end
      delete "/:id" do
        @user = User.find_by("id": params[:id])
        if @user.authenticated?(cookies[:remember_token])
          @user.destroy
          present @user, with: V1::Entities::UserEntity
        else
          error!("permission denied", 401)
        end
      end

      # GET[/:id/follow]
      desc "follow user"
      params do
        requires :id, type: Integer
      end
      get "/:id/follow" do
        if current_user.authenticated?(cookies[:remember_token])
          @user = User.find_by(id: params[:id])
          current_user.follow(@user)
        else
          error!("permission denied", 401)
        end
      end

      # GET[/:id/unfollow]
      desc "unfollow user"
      params do
        requires :id, type: Integer
      end
      get "/:id/unfollow" do
        if current_user.authenticated?(cookies[:remember_token])
          @user = User.find_by(id: params[:id])
          current_user.unfollow(@user)
        else
          error!("permission denied", 401)
        end
      end

      # GET[/:id/following]
      desc "follow user"
      params do
        requires :id, type: Integer
      end
      get "/:id/following" do
        following_list = []
        @users = current_user.following
        present @users, with: V1::Entities::UserEntity
      end

      # GET[/:id/followers]
      desc "unfollow user"
      params do
        requires :id, type: Integer
      end
      get "/:id/followers" do
        follower_list = []
        @users = current_user.followers
        present @users, with: V1::Entities::UserEntity
      end
    end
  end
end
