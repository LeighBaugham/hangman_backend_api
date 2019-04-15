class GamesController < ApplicationController
    def index
        @games = Game.all
        render json: @games, status: :ok
    end

    def show 
        @game = Game.find(params[:id])
        render json: @game, status: :ok
    end 
    
    def create
        user_id = JWT.decode(params[:token],'s3cr3t',true,{algorithm: 'HS512'})[0]
        full_params = game_params.merge({user_id: user_id})
        @game = Game.create(full_params)

        if @game
            @user = User.find(user_id)
            games = @user.games
            score = @user.games.sum(:score)
            render json: {total_score: score, games: games.map(&:without_user_id)}, status: :ok
        else
            render json: {errors: @game.errors.full_messages},
            status: :unprocessable_entity
        end 
    end 


    def destroy
        @game = Game.find(params[:id])
        @game.destroy
    end 

    private

    def game_params
        params.require(:game).permit(:word, :definition, :score)
    end 
    
end 