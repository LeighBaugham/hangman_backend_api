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
        @game = Game.create(game_params)
        if @game
            render json: @game, status: :ok
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
        params.permit(:user_id, :score, :word, :definition)
    end 
    
end 
end