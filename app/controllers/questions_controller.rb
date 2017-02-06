class QuestionsController < ApplicationController
    
    def show
        @game = Game.find(session[:game_id])
        @team1 = @game.teams.first
        @team2 = @game.teams.second
        @question = Question.find(params[:id])
    end
end
