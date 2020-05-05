module V1
  class Users < Grape::API
    resources :users do
      # GET[/]
      desc "returns all users"
      get "/" do
        @users = User.all
      end

      # GET[/:id]
      desc "returns an User"
      params do
        requires :id, type: Integer
      end
      get "/:id" do
        @user = User.find(params[:id])
      end

      # POST[/singup]
      desc "Create an User"
      params do
        requires :name, type: String
        requires :email, type: String
        requires :password, type: String
      end
      post "/singup" do
        @user = User.create(
          declared(params)
        )

        if @user.save
          @user
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
          @user
        else
          error!("Unauthorized. Invalid email or password.", 401)
        end
      end

      # DELETE[/:id]
      desc "Delete an User"
      params do
        requires :id, type: Integer
      end
      delete "/:id" do
        @user = User.find(params[:id])
        @user.destroy
      end
    end
  end
end
