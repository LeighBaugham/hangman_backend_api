class UsersController < ApplicationController
    def index
        @users = User.all
        render json: @users, status: :ok
    end
    
    def leaders
        #this isn't very effiecient, but it just needs to work right now
        top_users = User.all.sort_by(&:total_score).reverse.first(10)
        top_ten_scores = top_users.map{|user| {name: user.name, total_score: user.total_score}}
        #is there ever an error we should render here?
        render json: top_ten_scores, status: :ok
    end

    def show 
        @user = User.find(params[:id])
        render json: @user, status: :ok
    end 
    
    def create 
        
        @user = User.create(user_params)
        if @user
            # render json: @user, status: :ok
            token = JWT.encode(@user.id.to_s, 's3cr3t', 'HS512')
            render json: {token: token, user: @user.name }, status: :ok
        else
            render json: {errors: @user.errors.full_messages},
            status: :unprocessable_entity
        end 
    end 

    def update 
        @user = User.find(params[:id])
        @user.update(user_params)
    end 

    def destroy
        @user = User.find(params[:id])
        @user.destroy
    end 

    def login
        @user = User.find_by(name: params[:name])
        if @user && @user.authenticate(params[:password])
            token = JWT.encode(@user.id.to_s, 's3cr3t', 'HS512')
            render json: {token: token, user: @user.name }, status: :ok
        else 
            render json: {error: "User name or password not valid"}, status: :unauthorized
        end
    end

    def score
        user_id = JWT.decode(params[:token],'s3cr3t',true,{algorithm: 'HS512'})[0]
        @user = User.find(user_id)
        score = @user.games.sum(:score)
        render json: {total_score: score}
    end

    private

    def user_params
        params.permit(:name, :password)
    end 
end

