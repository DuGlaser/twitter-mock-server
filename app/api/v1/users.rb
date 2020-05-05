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
        present @user, with: V1::Entities::UserEntity
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
    end
  end
end
