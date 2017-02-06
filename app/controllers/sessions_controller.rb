class SessionsController < ApplicationController
    before_action :game_in_play, only: [:new]
    
    def new
       @game = Game.new
    end
    
    def create
        @game = Game.find(params[:game][:id])
        session[:game_id] = @game.id            #=> Better in Cookies?
        @game.is_active = true
        @game.teams.first.update_columns(name: params[:game][:team][:team1])
        @game.teams.second.update_columns(name: params[:game][:team][:team2])
        redirect_to game_path(@game.id)
    end       
    
    def destroy
        @game = Game.find(session[:game_id])
        session[:game_id] = nil
        @game.is_active = false
        @game.teams.each do |team|
            team.update_columns(name: nil, score: 0)
            team.save
        end
        @game.questions.each do |q|
            q.answered = false
            q.save
        end
        redirect_to root_url
    end
        
    private
    
        def game_in_play
            redirect_to(game_path(session[:game_id])) unless session[:game_id].nil?
        end
end
